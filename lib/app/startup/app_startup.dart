import 'package:material_ui/material_ui.dart';

import '../../core/services/logger_service.dart';
import '../../l10n/app_localizations.dart';
import '../app.dart';
import '../theme/app_theme.dart';
import 'startup_page.dart';

/// Shows startup feedback until all dependencies are ready to mount the router.
class AppStartup extends StatefulWidget {
  const AppStartup({required this.prepare, super.key});

  final Future<Widget> Function() prepare;

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  late Future<Widget> _preparation;

  @override
  void initState() {
    super.initState();
    _preparation = _prepare();
  }

  Future<Widget> _prepare() async {
    try {
      return await widget.prepare();
    } catch (error) {
      LoggerService.warning(
        'App initialization failed (${error.runtimeType}).',
      );
      rethrow;
    }
  }

  void _retry(Future<Widget> failedAttempt) {
    if (_preparation == failedAttempt) {
      setState(() {
        _preparation = _prepare();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final attempt = _preparation;
    return FutureBuilder<Widget>(
      future: attempt,
      builder: (context, snapshot) {
        final app = snapshot.data;
        if (app != null) return app;
        final failed =
            snapshot.connectionState == ConnectionState.done &&
            snapshot.hasError;
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          supportedLocales: AppLocalizations.supportedLocales,
          localeListResolutionCallback: resolveAppLocale,
          localizationsDelegates: appLocalizationsDelegates,
          builder: (_, _) => StartupPage(
            checkingAccount: false,
            onRetry: failed ? () => _retry(attempt) : null,
          ),
        );
      },
    );
  }
}

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/onboarding/data/onboarding_completion.dart';
import '../l10n/app_localizations.dart';
import 'app_router.dart';
import 'theme/app_theme.dart';

class MainApp extends StatefulWidget {
  const MainApp({required this.onboardingCompletion, super.key});

  final OnboardingCompletion onboardingCompletion;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    _loadRouter();
  }

  Future<void> _loadRouter() async {
    final completion = widget.onboardingCompletion;
    final completed = await completion.read();
    if (!mounted) return;
    setState(() {
      _router = createAppRouter(
        initialOnboardingComplete: completed,
        saveOnboardingCompletion: completion.save,
      );
    });
  }

  @override
  void dispose() {
    _router?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = _router;
    if (router == null) {
      return ColoredBox(color: darkTheme.scaffoldBackgroundColor);
    }
    return MaterialApp.router(
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (preferred, supported) =>
          basicLocaleListResolution(preferred, [
            const Locale('ar'),
            ...supported.where((locale) => locale.languageCode != 'ar'),
          ]),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
    );
  }
}

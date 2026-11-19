import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'app_router.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final _router = createAppRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
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

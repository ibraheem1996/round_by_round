import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/account_setup/presentation/account_setup_cubit.dart';
import '../features/authentication/presentation/login/login_cubit.dart';
import '../l10n/app_localizations.dart';
import 'app_router.dart';
import 'startup/app_entry_cubit.dart';
import 'startup/app_entry_state.dart';
import 'theme/app_theme.dart';

const appLocalizationsDelegates = [
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

Locale resolveAppLocale(List<Locale>? preferred, Iterable<Locale> supported) =>
    basicLocaleListResolution(preferred, [
      const Locale('ar'),
      ...supported.where((locale) => locale.languageCode != 'ar'),
    ]);

class MainApp extends StatefulWidget {
  const MainApp({
    required this.createLogin,
    required this.createAccountSetup,
    super.key,
  });

  final LoginCubit Function() createLogin;
  final AccountSetupCubit Function(String uid) createAccountSetup;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final StreamSubscription<AppEntryState> _entryChanges;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final entry = context.read<AppEntryCubit>();
    _router = createAppRouter(
      entry: entry,
      createLogin: widget.createLogin,
      createAccountSetup: widget.createAccountSetup,
    );
    _entryChanges = entry.stream
        .distinct(
          (before, after) =>
              before.destination == after.destination &&
              before.activeUid == after.activeUid,
        )
        .listen((state) => refreshAppRoute(_router, state.destination));
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
      localeListResolutionCallback: resolveAppLocale,
      localizationsDelegates: appLocalizationsDelegates,
    );
  }

  @override
  void dispose() {
    unawaited(_entryChanges.cancel());
    _router.dispose();
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/account_setup/presentation/account_setup_cubit.dart';
import '../features/authentication/presentation/login/login_cubit.dart';
import '../l10n/app_localizations.dart';
import 'app_route_guard.dart';
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
  final _routeRefresh = _RouteRefresh();
  late final StreamSubscription<AppEntryState> _entryChanges;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final entry = context.read<AppEntryCubit>();
    _router = createAppRouter(
      entry: entry,
      refreshListenable: _routeRefresh,
      createLogin: widget.createLogin,
      createAccountSetup: widget.createAccountSetup,
    );
    var previous = entry.state;
    _entryChanges = entry.stream
        .distinct(
          (before, after) =>
              before.destination == after.destination &&
              before.activeAccount == after.activeAccount,
        )
        .listen((state) {
          final leftAccount =
              previous is EntryReady &&
              previous.activeAccount != state.activeAccount;
          previous = state;
          if (leftAccount) {
            // Replace the old protected stack even if the next account is ready
            // before the router renders the startup gate.
            _router.go(AppRoutes.startup);
          } else {
            _routeRefresh.refresh();
          }
        });
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
    _routeRefresh.dispose();
    super.dispose();
  }
}

final class _RouteRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}

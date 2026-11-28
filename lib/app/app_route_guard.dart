import 'startup/app_entry_state.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const startup = '/startup';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const exerciseCatalog = '/library';
  static const accountSetup = '/account-setup';
}

const _entryPaths = {
  AppRoutes.startup,
  AppRoutes.onboarding,
  AppRoutes.login,
  AppRoutes.accountSetup,
};

String? appRouteRedirect(Uri location, EntryDestination entry) {
  final path = location.path;
  final destination = switch (entry) {
    EntryDestination.startup => AppRoutes.startup,
    EntryDestination.onboarding => AppRoutes.onboarding,
    EntryDestination.login => AppRoutes.login,
    EntryDestination.accountSetup => AppRoutes.accountSetup,
    EntryDestination.ready =>
      _entryPaths.contains(path) ? AppRoutes.home : null,
  };
  return destination == path ? null : destination;
}

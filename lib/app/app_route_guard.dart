import '../features/account_setup/presentation/account_setup_state.dart';
import '../features/authentication/presentation/session/session_state.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const startup = '/startup';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const accountSetup = '/account-setup';
}

const _entryPaths = {
  AppRoutes.startup,
  AppRoutes.onboarding,
  AppRoutes.login,
  AppRoutes.accountSetup,
};

String? appRouteRedirect(
  Uri location, {
  required SessionState session,
  required bool introCompleted,
  required AccountSetupState accountSetup,
}) {
  final path = location.path;
  final destination = switch (session) {
    SessionSignedIn() => switch (accountSetup) {
      AccountSetupReady() => _entryPaths.contains(path) ? AppRoutes.home : null,
      AccountSetupEditing() => AppRoutes.accountSetup,
      _ => AppRoutes.startup,
    },
    SessionSignedOut() =>
      introCompleted ? AppRoutes.login : AppRoutes.onboarding,
    _ => AppRoutes.startup,
  };
  return destination == path ? null : destination;
}

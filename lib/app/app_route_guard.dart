import '../features/authentication/presentation/session/session_state.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const startup = '/startup';
  static const onboarding = '/onboarding';
  static const login = '/login';
}

const _entryPaths = {AppRoutes.startup, AppRoutes.onboarding, AppRoutes.login};

String? appRouteRedirect(
  Uri location, {
  required SessionState session,
  required bool introCompleted,
}) {
  final path = location.path;
  final destination = switch (session) {
    SessionSignedIn() => _entryPaths.contains(path) ? AppRoutes.home : null,
    SessionSignedOut() =>
      introCompleted ? AppRoutes.login : AppRoutes.onboarding,
    _ => AppRoutes.startup,
  };
  return destination == path ? null : destination;
}

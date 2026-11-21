import 'package:flutter_test/flutter_test.dart';
import 'package:round_by_round/app/app_route_guard.dart';
import 'package:round_by_round/features/authentication/presentation/session/session_state.dart';

void main() {
  String? redirect(
    String location,
    SessionState session, {
    bool introCompleted = false,
  }) => appRouteRedirect(
    Uri.parse(location),
    session: session,
    introCompleted: introCompleted,
  );

  test('gates private destinations through startup, intro, and login', () {
    const privatePath = '/workouts/123/edit';
    expect(
      redirect(privatePath, const SessionState.restoring()),
      AppRoutes.startup,
    );
    expect(
      redirect(AppRoutes.startup, const SessionState.unavailable()),
      isNull,
    );

    const signedOut = SessionState.signedOut();
    expect(redirect(privatePath, signedOut), AppRoutes.onboarding);
    expect(
      redirect(privatePath, signedOut, introCompleted: true),
      AppRoutes.login,
    );
    expect(redirect(AppRoutes.startup, signedOut), AppRoutes.onboarding);
    expect(redirect(AppRoutes.onboarding, signedOut), isNull);
    expect(
      redirect(AppRoutes.onboarding, signedOut, introCompleted: true),
      AppRoutes.login,
    );
    expect(redirect(AppRoutes.login, signedOut, introCompleted: true), isNull);
  });

  test(
    'sends a signed-in user home from entry routes and allows direct links',
    () {
      const signedIn = SessionState.signedIn('user');
      for (final entry in [
        AppRoutes.startup,
        AppRoutes.onboarding,
        '/login?continue=%2F%3Fworkout%3D123',
      ]) {
        expect(redirect(entry, signedIn), AppRoutes.home);
      }
      expect(redirect('/?workout=123#summary', signedIn), isNull);
    },
  );
}

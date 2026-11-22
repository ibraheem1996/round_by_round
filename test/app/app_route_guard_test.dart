import 'package:flutter_test/flutter_test.dart';
import 'package:round_by_round/app/app_route_guard.dart';
import 'package:round_by_round/app/startup/app_entry_state.dart';

void main() {
  String? redirect(String location, EntryDestination destination) =>
      appRouteRedirect(Uri.parse(location), destination);

  test('selects a single entry destination and avoids redirect loops', () {
    const private = '/workouts/123/edit';
    for (final (destination, path) in [
      (EntryDestination.startup, AppRoutes.startup),
      (EntryDestination.onboarding, AppRoutes.onboarding),
      (EntryDestination.login, AppRoutes.login),
      (EntryDestination.accountSetup, AppRoutes.accountSetup),
    ]) {
      expect(redirect(private, destination), path);
      expect(redirect(path, destination), isNull);
    }
    expect(
      redirect(AppRoutes.login, EntryDestination.startup),
      AppRoutes.startup,
    );
    expect(
      redirect(AppRoutes.onboarding, EntryDestination.login),
      AppRoutes.login,
    );
  });

  test(
    'opens home from entry routes and preserves ready-session direct links',
    () {
      for (final entry in [
        AppRoutes.startup,
        AppRoutes.onboarding,
        '/login?continue=%2F%3Fworkout%3D123',
        AppRoutes.accountSetup,
      ]) {
        expect(redirect(entry, EntryDestination.ready), AppRoutes.home);
      }
      expect(redirect('/?workout=123#summary', EntryDestination.ready), isNull);
    },
  );
}

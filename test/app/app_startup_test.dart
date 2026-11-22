import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/features/authentication/presentation/login/login_page.dart';
import 'package:round_by_round/features/onboarding/presentation/onboarding_page.dart';

import '../support/mock_device_orientation.dart';
import '../support/test_auth_gateway.dart';
import '../support/test_preferences.dart';

void main() {
  final checking = find.text('Checking your session…');
  final retry = find.text('Try again');
  final home = find.text('Round by Round');

  setUp(() => mockDeviceOrientation('PortraitUp'));

  testWidgets('retries initialization and opens home for a cached session', (
    tester,
  ) async {
    final gateway = TestAuthGateway(userId: 'cached-user');
    addTearDown(gateway.close);
    final platform = tester.platformDispatcher;
    platform.localesTestValue = const [Locale('en')];
    platform.defaultRouteNameTestValue = '/?workout=123#summary';
    addTearDown(platform.clearAllTestValues);

    var failStartup = true;
    final retryInitialization = Completer<void>();
    final preferences = TestPreferences();
    await tester.pumpWidget(
      testApp(
        preferences,
        gateway,
        beforeInitialize: () async {
          if (failStartup) throw Exception('Firebase startup failed');
          await retryInitialization.future;
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Couldn’t check your session. Try again.'),
      findsOneWidget,
    );
    expect(gateway.sessionListeners, 0);

    failStartup = false;
    await tester.tap(retry);
    await tester.pump();
    expect(checking, findsOneWidget);
    expect(retry, findsNothing);

    retryInitialization.complete();
    await tester.pumpAndSettle();
    final router = GoRouter.of(tester.element(home));
    expect(router.routerDelegate.currentConfiguration.uri, Uri.parse('/'));
    expect(gateway.calls, isEmpty);
    expect(preferences.writes, 0);
    expect(find.byType(LoginPage), findsNothing);
    expect(find.byType(OnboardingPage), findsNothing);

    router.go('/?workout=456#rounds');
    await tester.pumpAndSettle();
    expect(
      router.routerDelegate.currentConfiguration.uri,
      Uri.parse('/?workout=456#rounds'),
    );
  });

  testWidgets('session timeout fails closed and can retry without rebooting', (
    tester,
  ) async {
    final gateway = TestAuthGateway(delayInitialEvent: true);
    addTearDown(gateway.close);
    tester.platformDispatcher.localesTestValue = const [Locale('en')];
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    var initializations = 0;
    await tester.pumpWidget(
      testApp(
        TestPreferences(),
        gateway,
        beforeInitialize: () async => initializations++,
      ),
    );
    await tester.pump();
    expect(checking, findsOneWidget);
    final router = GoRouter.of(tester.element(checking));
    router.go('/login');
    await tester.pump();
    expect(checking, findsOneWidget);

    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    expect(retry, findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
    expect(home, findsNothing);

    gateway.delayInitialEvent = false;
    await tester.tap(retry);
    await tester.pumpAndSettle();
    expect(initializations, 1);
    expect(gateway.sessionListeners, 1);
    expect(find.byType(OnboardingPage), findsOneWidget);
    router.go('/');
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingPage), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    expect(gateway.sessionListeners, 0);
  });
}

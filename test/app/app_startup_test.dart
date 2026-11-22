import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/app/startup/app_startup.dart';
import 'package:round_by_round/features/account_setup/account_profile.dart';
import 'package:round_by_round/features/account_setup/presentation/account_setup_page.dart';
import 'package:round_by_round/features/authentication/auth_gateway.dart';
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

  testWidgets('bootstrap coalesces retries before the next frame', (
    tester,
  ) async {
    final completing = Completer<Widget>();
    var attempts = 0;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 280);
    tester.platformDispatcher.localesTestValue = const [Locale('ar')];
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    await tester.pumpWidget(
      AppStartup(
        prepare: () async {
          if (attempts++ == 0) throw StateError('preparation failed');
          return completing.future;
        },
      ),
    );
    await tester.pumpAndSettle();
    final retryButton = find.widgetWithText(FilledButton, 'إعادة المحاولة');
    await tester.ensureVisible(retryButton);
    expect(retryButton.hitTestable(), findsOneWidget);
    final retryAction = tester.widget<FilledButton>(retryButton).onPressed!;
    retryAction();
    retryAction();
    await tester.pump();
    expect(attempts, 2);
    expect(find.text('جارٍ التحقق من جلستك…'), findsOneWidget);
    completing.complete(const SizedBox.shrink());
    await tester.pumpAndSettle();
    expect(retryButton, findsNothing);
  });

  testWidgets(
    'a different ready account cannot inherit the previous protected route',
    (tester) async {
      final gateway = TestAuthGateway(userId: 'first');
      addTearDown(gateway.close);
      tester.platformDispatcher.localesTestValue = const [Locale('en')];
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      await tester.pumpWidget(testApp(TestPreferences(), gateway));
      await tester.pumpAndSettle();
      final router = GoRouter.of(tester.element(home));
      unawaited(router.push<void>('/?workout=old-account'));
      await tester.pumpAndSettle();
      expect(router.canPop(), isTrue);

      gateway.emitSession('another-user');
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.uri, Uri.parse('/'));
      expect(router.canPop(), isFalse);
    },
  );

  testWidgets(
    'completes onboarding, login and weight setup with one live account watch',
    (tester) async {
      final gateway = TestAuthGateway()
        ..onSignIn = () async => SignInResult.success;
      final accountRead = StreamController<AccountProfile?>.broadcast();
      final accounts = TestAccountRepository()
        ..onWatch = (_) => accountRead.stream;
      final preferences = TestPreferences();
      addTearDown(gateway.close);
      addTearDown(accountRead.close);
      tester.platformDispatcher.localesTestValue = const [Locale('en')];
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      await tester.pumpWidget(
        testApp(preferences, gateway, accounts: accounts),
      );
      await tester.pumpAndSettle();

      for (var step = 0; step < 2; step++) {
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();
      expect(preferences.writes, 1);

      final google = find.text('Continue with Google');
      await tester.ensureVisible(google);
      await tester.tap(google);
      await tester.pump();
      gateway.emitSession('owner');
      await tester.pump();
      await tester.pump();
      final accountChecking = find.text('Checking your account…');
      expect(accountChecking, findsOneWidget);
      final router = GoRouter.of(tester.element(accountChecking));
      router.go('/?workout=123');
      await tester.pump();
      expect(find.byType(AccountSetupPage), findsNothing);
      expect(home, findsNothing);

      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();
      expect(
        find.text('Couldn’t check your account. Try again.'),
        findsOneWidget,
      );
      expect(gateway.sessionListeners, 1);
      expect(accountRead.hasListener, isTrue);

      accountRead.add(null);
      await tester.pumpAndSettle();
      final save = find.text('Let’s start');
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(accounts.saves, [
        ('owner', const AccountProfile(bodyWeightKg: 80)),
      ]);
      expect(router.routerDelegate.currentConfiguration.uri, Uri.parse('/'));
      expect(find.byType(AccountSetupPage), findsNothing);

      expect(accountRead.hasListener, isTrue);
      accountRead.addError(StateError('cloud unavailable after local save'));
      await tester.pumpAndSettle();
      expect(home, findsOneWidget);
      expect(accounts.observations, ['owner']);

      gateway.emitSession(null);
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
      expect(accountRead.hasListener, isFalse);
    },
  );
}

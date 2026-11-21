import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/app/app.dart';
import 'package:round_by_round/features/authentication/auth_gateway.dart';
import 'package:round_by_round/features/authentication/presentation/auth_cubit.dart';
import 'package:round_by_round/features/authentication/presentation/auth_state.dart';
import 'package:round_by_round/features/authentication/presentation/login_page.dart';
import 'package:round_by_round/features/onboarding/data/onboarding_completion.dart';
import 'package:round_by_round/features/onboarding/presentation/onboarding_page.dart';
import 'package:round_by_round/l10n/app_localizations.dart';

import '../../support/mock_device_orientation.dart';
import '../../support/test_auth_gateway.dart';
import '../../support/test_preferences.dart';

void main() {
  final login = find.byType(LoginPage);
  final onboarding = find.byType(OnboardingPage);

  setUp(() => mockDeviceOrientation('PortraitUp'));

  testWidgets(
    'waits for session, guards direct routes, and retries listening',
    (tester) async {
      final gateway = TestAuthGateway(delayInitialEvent: true);
      addTearDown(gateway.close);
      _locale(tester, 'en');

      final cubit = AuthCubit(gateway);
      await tester.pumpWidget(
        MainApp(
          initialize: () async => (
            onboardingCompletion: OnboardingCompletion(TestPreferences()),
            authCubit: cubit,
          ),
        ),
      );
      await tester.pump();
      final checking = find.text('Checking your session…');
      expect(checking, findsOneWidget);
      expect(login, findsNothing);
      expect(onboarding, findsNothing);

      final router = GoRouter.of(tester.element(checking));
      router.go('/login');
      await tester.pump();
      expect(checking, findsOneWidget);
      gateway.failSession();
      await tester.pump();
      final retry = find.text('Try again');
      expect(retry, findsOneWidget);
      gateway.delayInitialEvent = false;
      await tester.tap(retry);
      await tester.pump();
      expect(cubit.state, isA<AuthSignedOut>());
      await tester.pumpAndSettle();

      expect(onboarding, findsOneWidget);
      router.go('/');
      await tester.pumpAndSettle();
      expect(onboarding, findsOneWidget);
      expect(login, findsNothing);
    },
  );

  testWidgets('can retry the app startup after Firebase setup fails', (
    tester,
  ) async {
    final gateway = TestAuthGateway(userId: 'restored-user');
    addTearDown(gateway.close);
    _locale(tester, 'en');
    var failStartup = true;
    await tester.pumpWidget(
      MainApp(
        initialize: () async {
          if (failStartup) throw Exception('Firebase startup failed');
          return (
            onboardingCompletion: OnboardingCompletion(TestPreferences()),
            authCubit: AuthCubit(gateway),
          );
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Couldn’t check your session. Try again.'),
      findsOneWidget,
    );
    failStartup = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Round by Round'), findsOneWidget);
    expect(login, findsNothing);
    expect(onboarding, findsNothing);
  });

  testWidgets('Apple tap is inert and Google can retry then unlock the app', (
    tester,
  ) async {
    final gateway = TestAuthGateway();
    addTearDown(gateway.close);
    _locale(tester, 'en');
    await tester.pumpWidget(testApp(TestPreferences(completed: true), gateway));
    await tester.pumpAndSettle();
    final context = tester.element(login);
    final strings = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);
    final google = find.text(strings.authContinueGoogle);
    final apple = find.widgetWithText(FilledButton, strings.authContinueApple);

    router.go('/');
    await tester.pumpAndSettle();
    expect(login, findsOneWidget);
    await tester.ensureVisible(apple);
    await tester.tap(apple, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(gateway.calls, isEmpty);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(login, findsOneWidget);

    await tester.ensureVisible(google);
    await tester.tap(google);
    await tester.pumpAndSettle();
    expect(find.text(strings.authSignInFailed), findsNothing);
    expect(google, findsOneWidget);

    gateway.onSignIn = () async => SignInResult.networkError;
    await tester.tap(google);
    await tester.pumpAndSettle();
    expect(find.text(strings.authOffline), findsOneWidget);

    gateway.onSignIn = () async => SignInResult.success;
    await tester.ensureVisible(google);
    await tester.tap(google);
    await tester.pump();
    expect(find.text(strings.authSigningIn), findsOneWidget);
    gateway.emitSession('google-test-uid');
    await tester.pumpAndSettle();
    expect(find.text(strings.appName), findsOneWidget);

    router.go('/login');
    await tester.pumpAndSettle();
    expect(login, findsNothing);

    gateway.emitSession(null);
    await tester.pumpAndSettle();
    expect(login, findsOneWidget);
  });

  for (final language in ['ar', 'en']) {
    testWidgets('login buttons stay reachable at 200% in $language', (
      tester,
    ) async {
      final gateway = TestAuthGateway();
      addTearDown(gateway.close);
      addTearDown(tester.view.reset);
      _locale(tester, language);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      await tester.pumpWidget(
        testApp(TestPreferences(completed: true), gateway),
      );
      await tester.pumpAndSettle();
      final strings = AppLocalizations.of(tester.element(login))!;
      final buttons = [
        find.text(strings.authContinueApple),
        find.text(strings.authContinueGoogle),
      ];

      for (final size in [
        const Size(320, 690),
        const Size(430, 240),
        const Size(700, 860),
        const Size(1024, 760),
      ]) {
        tester.view.physicalSize = size;
        await tester.pumpAndSettle();
        for (final button in buttons) {
          await tester.ensureVisible(button);
          await tester.pumpAndSettle();
          expect(button.hitTestable(), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
      }
    });
  }
}

void _locale(WidgetTester tester, String language) {
  tester.platformDispatcher.localesTestValue = [Locale(language)];
  addTearDown(tester.platformDispatcher.clearAllTestValues);
}

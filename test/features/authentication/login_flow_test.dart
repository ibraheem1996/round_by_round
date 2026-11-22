import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/features/authentication/auth_gateway.dart';
import 'package:round_by_round/features/authentication/presentation/login/login_cubit.dart';
import 'package:round_by_round/features/authentication/presentation/login/login_page.dart';
import 'package:round_by_round/features/authentication/presentation/login/login_state.dart';
import 'package:round_by_round/l10n/app_localizations.dart';

import '../../support/mock_device_orientation.dart';
import '../../support/test_auth_gateway.dart';
import '../../support/test_preferences.dart';

void main() {
  final login = find.byType(LoginPage);

  setUp(() => mockDeviceOrientation('PortraitUp'));

  testWidgets('Apple tap is inert and Google can retry then unlock the app', (
    tester,
  ) async {
    final gateway = TestAuthGateway();
    addTearDown(gateway.close);
    _locale(tester, 'en');
    await tester.pumpWidget(testApp(TestPreferences(completed: true), gateway));
    await tester.pumpAndSettle();
    final context = tester.element(login);
    final firstLogin = context.read<LoginCubit>();
    final strings = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);
    final google = find.text(strings.authContinueGoogle);
    final apple = find.widgetWithText(FilledButton, strings.authContinueApple);

    router.go('/?workout=123#summary');
    await tester.pumpAndSettle();
    expect(login, findsOneWidget);
    expect(router.routerDelegate.currentConfiguration.uri, Uri.parse('/login'));
    expect(find.text(strings.appName), findsNothing);
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
    await tester.pump(const Duration(seconds: 10));
    expect(find.text(strings.authSignInFailed), findsOneWidget);
    await tester.ensureVisible(google);
    await tester.tap(google);
    await tester.pump();
    expect(find.text(strings.authSigningIn), findsOneWidget);
    gateway.emitSession('google-test-uid');
    await tester.pumpAndSettle();
    expect(find.text(strings.appName), findsOneWidget);
    expect(router.routerDelegate.currentConfiguration.uri, Uri.parse('/'));
    expect(firstLogin.isClosed, isTrue);

    router.go('/login');
    await tester.pumpAndSettle();
    expect(login, findsNothing);

    unawaited(router.push<void>('/?workout=456'));
    await tester.pumpAndSettle();
    expect(router.canPop(), isTrue);

    gateway.emitSession(null);
    await tester.pumpAndSettle();
    final newLogin = tester.element(login).read<LoginCubit>();
    expect(newLogin, isNot(same(firstLogin)));
    expect(newLogin.state, const LoginState.idle());
    expect(router.canPop(), isFalse);
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

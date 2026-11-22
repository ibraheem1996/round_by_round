import 'dart:async';

// ignore: deprecated_member_use
import 'package:flutter/cupertino.dart' show CupertinoPicker;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/features/account_setup/account_profile.dart';
import 'package:round_by_round/features/account_setup/presentation/account_setup_page.dart';
import 'package:round_by_round/l10n/app_localizations.dart';

import '../../support/mock_device_orientation.dart';
import '../../support/test_auth_gateway.dart';
import '../../support/test_preferences.dart';

void main() {
  final page = find.byType(AccountSetupPage);

  setUp(() => mockDeviceOrientation('PortraitUp'));

  testWidgets(
    'keeps the selected weight on failure and waits for durable save',
    (tester) async {
      final auth = TestAuthGateway(userId: 'owner');
      addTearDown(auth.close);
      final account = TestAccountRepository(profile: null);
      tester.platformDispatcher.localesTestValue = const [Locale('en')];
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      await tester.pumpWidget(
        testApp(TestPreferences(), auth, accounts: account),
      );
      await tester.pumpAndSettle();
      final picker = tester.widget<CupertinoPicker>(
        find.byType(CupertinoPicker),
      );
      final controller = picker.scrollController!;
      final router = GoRouter.of(tester.element(page));
      expect(controller.selectedItem, 80);
      controller.jumpToItem(220);
      await tester.pumpAndSettle();
      expect(find.textContaining('150.0', findRichText: true), findsOneWidget);
      controller.jumpToItem(0);
      await tester.pumpAndSettle();
      expect(find.textContaining('40.0', findRichText: true), findsOneWidget);

      account.beforeSave = () async => throw StateError('unavailable');
      final save = find.text('Let’s start');
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(
        find.text('Couldn’t save your weight. Try again.'),
        findsOneWidget,
      );
      expect(controller.selectedItem, 0);
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        '/account-setup',
      );

      final accepted = Completer<void>();
      account.beforeSave = () => accepted.future;
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(
              find.ancestor(of: save, matching: find.byType(FilledButton)),
            )
            .onPressed,
        isNull,
      );
      expect(page, findsOneWidget);
      accepted.complete();
      await tester.pumpAndSettle();
      expect(account.saves, [
        ('owner', const AccountProfile(bodyWeightKg: 40)),
        ('owner', const AccountProfile(bodyWeightKg: 40)),
      ]);
      expect(router.routerDelegate.currentConfiguration.uri.path, '/');
      expect(page, findsNothing);
    },
  );

  testWidgets('ignores a save that finishes after switching accounts', (
    tester,
  ) async {
    final auth = TestAuthGateway(userId: 'first');
    addTearDown(auth.close);
    final account = TestAccountRepository(profile: null);
    final previousSave = Completer<void>();
    account.beforeSave = () => previousSave.future;
    tester.platformDispatcher.localesTestValue = const [Locale('en')];
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    await tester.pumpWidget(
      testApp(TestPreferences(), auth, accounts: account),
    );
    await tester.pumpAndSettle();

    final picker = find.byType(CupertinoPicker);
    tester.widget<CupertinoPicker>(picker).scrollController!.jumpToItem(100);
    await tester.pumpAndSettle();
    final save = find.text('Let’s start');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(account.saves.single.$1, 'first');

    auth.emitSession('second');
    await tester.pumpAndSettle();
    previousSave.complete();
    await tester.pumpAndSettle();
    expect(page, findsOneWidget);
    expect(
      tester.widget<CupertinoPicker>(picker).scrollController!.selectedItem,
      80,
    );
  });

  for (final language in ['ar', 'en']) {
    testWidgets('setup action stays reachable at 200% in $language', (
      tester,
    ) async {
      final auth = TestAuthGateway(userId: 'owner');
      addTearDown(auth.close);
      addTearDown(tester.view.reset);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.localesTestValue = [Locale(language)];
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      await tester.pumpWidget(
        testApp(
          TestPreferences(),
          auth,
          accounts: TestAccountRepository(profile: null),
        ),
      );
      await tester.pumpAndSettle();
      final strings = AppLocalizations.of(tester.element(page))!;

      for (final size in [
        const Size(320, 690),
        const Size(430, 240),
        const Size(700, 860),
        const Size(1024, 760),
      ]) {
        tester.view.physicalSize = size;
        await tester.pumpAndSettle();
        final save = find.text(strings.accountWeightContinue);
        await tester.ensureVisible(save);
        expect(save.hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  }
}

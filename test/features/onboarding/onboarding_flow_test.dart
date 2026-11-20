import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/app/app.dart';
import 'package:round_by_round/core/assets/app_assets.dart';
import 'package:round_by_round/features/onboarding/data/onboarding_completion.dart';
import 'package:round_by_round/features/onboarding/presentation/onboarding_page.dart';
import 'package:round_by_round/features/onboarding/presentation/widgets/onboarding_backdrop.dart';
import 'package:round_by_round/l10n/app_localizations.dart';
import 'package:round_by_round/shared/design_system/app_text_scale_limits.dart';

import '../../support/mock_device_orientation.dart';
import '../../support/test_preferences.dart';

void main() {
  final page = find.byType(OnboardingPage);

  testWidgets('swipes between RTL slides and stays open on system back', (
    tester,
  ) async {
    mockDeviceOrientation('PortraitUp');
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 780);
    tester.platformDispatcher.localesTestValue = const [Locale('ar')];
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    await _launch(tester, TestPreferences());
    final strings = AppLocalizations.of(tester.element(page))!;
    final pager = find.byType(PageView);
    final swipe = Offset(tester.getSize(pager).width * .8, 0);

    expect(find.text(strings.onboardingLogDescription), findsOneWidget);
    await tester.drag(pager, swipe);
    await tester.pumpAndSettle();
    expect(find.text(strings.onboardingPreviousDescription), findsOneWidget);
    expect(
      tester.widget<OnboardingBackdrop>(find.byType(OnboardingBackdrop)).image,
      AppAssets.onboardingDeadlift,
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text(strings.onboardingPreviousDescription), findsOneWidget);

    await tester.drag(pager, -swipe);
    await tester.pumpAndSettle();
    expect(find.text(strings.onboardingLogDescription), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text(strings.onboardingPreviousDescription), findsOneWidget);
  });

  testWidgets('recovers from a failed save and skips onboarding on relaunch', (
    tester,
  ) async {
    mockDeviceOrientation('PortraitUp');
    final pendingSave = Completer<void>();
    var failSave = true;
    final preferences = TestPreferences(
      beforeWrite: () async {
        if (failSave) throw Exception('Could not save completion');
        await pendingSave.future;
      },
    );

    await _launch(tester, preferences);
    final strings = AppLocalizations.of(tester.element(page))!;
    await _tapAction(tester, strings.onboardingContinue);
    await _tapAction(tester, strings.onboardingContinue);
    expect(find.text(strings.onboardingRoutinesDescription), findsOneWidget);
    expect(preferences.writes, 0);

    await _tapAction(tester, strings.onboardingStart);
    expect(find.text(strings.onboardingSaveFailed), findsOneWidget);
    expect(page, findsOneWidget);
    expect(preferences.writes, 1);

    final errorMessage = tester.widget<SnackBar>(find.byType(SnackBar));
    await tester.pump(errorMessage.duration);
    await tester.pumpAndSettle();

    failSave = false;
    await _tapAction(tester, strings.onboardingStart);
    final start = find.widgetWithText(FilledButton, strings.onboardingStart);
    await tester.tapAt(tester.getCenter(start));
    await tester.pump();
    expect(preferences.writes, 2);
    expect(page, findsOneWidget);

    pendingSave.complete();
    await tester.pumpAndSettle();
    expect(find.text(strings.appName), findsOneWidget);
    expect(page, findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await _launch(tester, preferences);
    expect(find.text(strings.appName), findsOneWidget);
    expect(page, findsNothing);
    expect(preferences.writes, 2);
  });

  testWidgets('keeps the current step and action reachable on a short window', (
    tester,
  ) async {
    mockDeviceOrientation('LandscapeLeft');
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(960, 540);
    tester.view.padding = const FakeViewPadding(left: 32, bottom: 24);
    tester.platformDispatcher.localesTestValue = const [Locale('en')];
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    await _launch(tester, TestPreferences());
    final strings = AppLocalizations.of(tester.element(page))!;
    await _tapAction(tester, strings.onboardingContinue);

    tester.view.physicalSize = const Size(430, 210);
    tester.platformDispatcher.textScaleFactorTestValue = 3;
    await tester.pumpAndSettle();

    final description = find.text(strings.onboardingPreviousDescription);
    expect(description, findsOneWidget);
    final style = tester.widget<Text>(description).style!;
    final scaler = MediaQuery.textScalerOf(tester.element(description));
    final fontSize = style.fontSize!;
    expect(
      scaler.scale(fontSize),
      closeTo(fontSize * AppTextScaleLimits.onboarding, .001),
    );
    expect(
      tester.getRect(find.byType(OnboardingBackdrop)),
      Offset.zero & tester.view.physicalSize,
    );
    expect(tester.takeException(), isNull);

    await _tapAction(tester, strings.onboardingContinue);
    expect(find.text(strings.onboardingRoutinesDescription), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _launch(WidgetTester tester, TestPreferences preferences) async {
  await tester.pumpWidget(
    MainApp(onboardingCompletion: OnboardingCompletion(preferences)),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapAction(WidgetTester tester, String label) async {
  final action = find.widgetWithText(FilledButton, label);
  await tester.ensureVisible(action);
  await tester.pumpAndSettle();
  await tester.tap(action);
  await tester.pumpAndSettle();
}

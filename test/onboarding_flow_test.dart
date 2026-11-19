import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/app/app.dart';
import 'package:round_by_round/core/assets/app_assets.dart';
import 'package:round_by_round/features/onboarding/data/onboarding_completion.dart';
import 'package:round_by_round/features/onboarding/presentation/widgets/onboarding_backdrop.dart';
import 'package:round_by_round/l10n/app_localizations.dart';

import 'support/test_preferences.dart';

void main() {
  for (final (locale, size, brightness) in [
    (const Locale('ar'), const Size(320, 370), Brightness.light),
    (const Locale('en'), const Size(1024, 420), Brightness.dark),
  ]) {
    testWidgets('onboarding swipe and completion in ${locale.languageCode}', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      tester.view.padding = const FakeViewPadding(top: 24, bottom: 16);
      tester.platformDispatcher.localesTestValue = [locale];
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      tester.platformDispatcher.platformBrightnessTestValue = brightness;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearAllTestValues);

      final allowSave = Completer<void>();
      final preferences = TestPreferences(beforeWrite: allowSave.future);
      final completion = OnboardingCompletion(preferences);

      await tester.pumpWidget(MainApp(onboardingCompletion: completion));
      await tester.pumpAndSettle();
      final backdrop = find.byType(OnboardingBackdrop);
      final strings = AppLocalizations.of(tester.element(backdrop))!;
      final direction = locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr;
      expect(Directionality.of(tester.element(backdrop)), direction);

      void checkStep(String description, String path) {
        expect(find.text(description), findsOneWidget);
        expect(
          tester.getRect(backdrop),
          Offset.zero & tester.view.physicalSize,
        );
        final photo = tester.widget<OnboardingBackdrop>(backdrop).image;
        expect(photo, path);
        expect(tester.takeException(), isNull);
      }

      Future<void> tapAction(String label) async {
        final button = find.widgetWithText(FilledButton, label);
        await tester.ensureVisible(button);
        await tester.pumpAndSettle();
        await tester.tap(button);
        await tester.pumpAndSettle();
      }

      Future<void> swipe({
        required bool forward,
        VoidCallback? checkBeforePageChange,
        VoidCallback? checkDuringDrag,
      }) async {
        final rtl = direction == TextDirection.rtl;
        final sign = forward == rtl ? 1 : -1;
        final width = tester.view.physicalSize.width;
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(PageView)),
        );
        await gesture.moveBy(Offset(sign * width * 0.15, 0));
        await tester.pump();
        checkBeforePageChange?.call();
        await gesture.moveBy(Offset(sign * width * 0.70, 0));
        await tester.pump();
        checkDuringDrag?.call();
        await gesture.up();
        await tester.pumpAndSettle();
      }

      checkStep(strings.onboardingLogDescription, AppAssets.onboardingGrip);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      checkStep(strings.onboardingLogDescription, AppAssets.onboardingGrip);

      if (locale.languageCode == 'ar') {
        final copy = find.byType(SingleChildScrollView);
        final scrollable = find.descendant(
          of: copy,
          matching: find.byType(Scrollable),
        );
        final position = tester.state<ScrollableState>(scrollable).position;
        await tester.drag(copy, const Offset(0, -100));
        await tester.pumpAndSettle();
        expect(position.pixels, greaterThan(0));
        position.jumpTo(0);
        await tester.pumpAndSettle();
      }

      final description = find.text(strings.onboardingLogDescription);
      final button = find.widgetWithText(
        FilledButton,
        strings.onboardingContinue,
      );
      final initialTextPosition = tester.getTopLeft(description);
      final initialButtonPosition = tester.getTopLeft(button);
      final firstImage = find.byWidgetPredicate(
        (widget) =>
            widget is OnboardingBackdrop &&
            widget.image == AppAssets.onboardingGrip,
      );
      await swipe(
        forward: true,
        checkBeforePageChange: () {
          expect(tester.getTopLeft(description), initialTextPosition);
          expect(tester.getTopLeft(button), initialButtonPosition);
        },
        checkDuringDrag: () {
          expect(tester.getTopLeft(firstImage).dx.abs(), greaterThan(20));
          final nextDescription = find.text(
            strings.onboardingPreviousDescription,
          );
          expect(nextDescription, findsOneWidget);
          expect(tester.getTopLeft(nextDescription).dx, initialTextPosition.dx);
          expect(tester.getTopLeft(button), initialButtonPosition);
        },
      );
      checkStep(
        strings.onboardingPreviousDescription,
        AppAssets.onboardingDeadlift,
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      checkStep(
        strings.onboardingPreviousDescription,
        AppAssets.onboardingDeadlift,
      );
      await swipe(forward: false);
      checkStep(strings.onboardingLogDescription, AppAssets.onboardingGrip);

      tester.view.physicalSize = const Size(700, 400);
      await tester.pumpAndSettle();
      await tapAction(strings.onboardingContinue);
      await tapAction(strings.onboardingContinue);
      checkStep(
        strings.onboardingRoutinesDescription,
        AppAssets.onboardingWeightPlates,
      );
      expect(preferences.writes, 0);
      await tapAction(strings.onboardingStart);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(preferences.writes, 1);
      allowSave.complete();
      await tester.pumpAndSettle();
      expect(find.text(strings.appName), findsOneWidget);
      expect(backdrop, findsNothing);
      expect(preferences.values['onboarding_complete_v1'], isTrue);
    });
  }
}

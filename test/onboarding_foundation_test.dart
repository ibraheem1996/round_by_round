import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/app/theme/app_theme.dart';
import 'package:round_by_round/app/theme/app_typography.dart';
import 'package:round_by_round/core/assets/app_assets.dart';
import 'package:round_by_round/features/onboarding/presentation/widgets/onboarding_backdrop.dart';
import 'package:round_by_round/features/onboarding/presentation/widgets/onboarding_cta.dart';

void main() {
  for (final (locale, size, brightness, title, description, label) in [
    (
      const Locale('ar'),
      const Size(320, 430),
      Brightness.dark,
      'سجّل كل جولة',
      'تتبّع تقدمك أثناء التمرين',
      'متابعة إلى الخطوة التالية',
    ),
    (
      const Locale('en'),
      const Size(1024, 380),
      Brightness.light,
      'Log every set',
      'Follow your progress as you train',
      'Continue to the next onboarding step',
    ),
  ]) {
    testWidgets('foundation preview in ${locale.languageCode}', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      tester.view.padding = const FakeViewPadding(left: 18, bottom: 16);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      tester.platformDispatcher.platformBrightnessTestValue = brightness;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearAllTestValues);

      final bytes = File(AppAssets.onboardingGrip).readAsBytesSync();
      final image = await tester.runAsync(() async {
        final codec = await ui.instantiateImageCodec(bytes);
        try {
          return (await codec.getNextFrame()).image;
        } finally {
          codec.dispose();
        }
      });
      expect(image, isNotNull);
      addTearDown(image!.dispose);
      var activations = 0;
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                const OnboardingBackdrop(image: AppAssets.onboardingGrip),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 245),
                        child: Builder(
                          builder: (context) {
                            final text = context.appTypography;
                            return Column(
                              children: [
                                Text(title, style: text.pageTitle),
                                Text(description, style: text.supportingBody),
                                OnboardingCta(
                                  label: label,
                                  onPressed: () => activations++,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final backdrop = find.byType(OnboardingBackdrop);
      expect(tester.getRect(backdrop), Offset.zero & size);
      final photo = tester.widget<Image>(
        find.descendant(of: backdrop, matching: find.byType(Image)),
      );
      expect(photo.fit, BoxFit.cover);
      expect((photo.image as AssetImage).assetName, AppAssets.onboardingGrip);

      final cta = find.byType(FilledButton);
      final text = find.text(label);
      final arrow = find.byIcon(Icons.arrow_forward);
      final context = tester.element(text);
      expect(Theme.of(context).brightness, brightness);
      expect(MediaQuery.textScalerOf(context).scale(16), 32);
      expect(tester.getSize(text).height, greaterThan(40));
      expect(tester.getSize(cta).width, lessThan(size.width));
      expect(tester.widget<Icon>(arrow).icon!.matchTextDirection, isTrue);
      final arrowX = tester.getCenter(arrow).dx;
      final textX = tester.getCenter(text).dx;
      expect(
        locale.languageCode == 'ar' ? arrowX < textX : arrowX > textX,
        isTrue,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(activations, 1);

      await tester.ensureVisible(cta);
      await tester.tap(cta);
      await tester.pumpAndSettle();
      expect(activations, 2);
    });
  }
}

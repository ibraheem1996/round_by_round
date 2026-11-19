import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/app/app.dart';

void main() {
  testWidgets('device languages, Arabic fallback and system brightness', (
    tester,
  ) async {
    final platform = tester.platformDispatcher;
    addTearDown(platform.clearAllTestValues);
    platform.localesTestValue = const [Locale('fr')];
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();
    final arabic = tester.element(find.text('جولة بجولة'));
    expect(Directionality.of(arabic), TextDirection.rtl);
    expect(MaterialLocalizations.of(arabic).backButtonTooltip, isNot('Back'));

    platform.localesTestValue = const [Locale('en', 'GB')];
    await tester.pumpAndSettle();
    final english = tester.element(find.text('Round by Round'));
    expect(Directionality.of(english), TextDirection.ltr);
    expect(MaterialLocalizations.of(english).backButtonTooltip, 'Back');
    for (final brightness in [Brightness.dark, Brightness.light]) {
      platform.platformBrightnessTestValue = brightness;
      await tester.pumpAndSettle();
      expect(Theme.of(english).colorScheme.brightness, brightness);
    }
  });

  for (final arabic in [false, true]) {
    testWidgets('unknown route adapts and returns home (Arabic: $arabic)', (
      tester,
    ) async {
      final platform = tester.platformDispatcher;
      addTearDown(platform.clearAllTestValues);
      platform.localesTestValue = [Locale(arabic ? 'ar' : 'en')];
      final home = find.text(arabic ? 'جولة بجولة' : 'Round by Round');
      final message = find.text(
        arabic ? 'الصفحة غير موجودة' : 'Page not found',
      );
      final action = find.text(arabic ? 'العودة إلى البداية' : 'Back to start');
      Future<void> resize(double width) async {
        await tester.pumpWidget(
          Center(
            child: SizedBox(width: width, height: 180, child: const MainApp()),
          ),
        );
        await tester.pumpAndSettle();
      }

      await resize(700);
      GoRouter.of(tester.element(home)).go('/missing');
      await tester.pumpAndSettle();
      final text = tester.getRect(message);
      final button = tester.getRect(action);
      expect(
        arabic ? text.left >= button.right : text.right <= button.left,
        isTrue,
      );

      await resize(120);
      expect(
        tester.getRect(action).top,
        greaterThanOrEqualTo(tester.getRect(message).bottom),
      );
      await resize(700);
      final rowWidth =
          tester.getSize(message).width +
          tester.getSize(find.byType(TextButton)).width;
      await resize(rowWidth + 10);
      platform.textScaleFactorTestValue = 2;
      await tester.pumpAndSettle();
      expect(
        tester.getRect(action).top,
        greaterThanOrEqualTo(tester.getRect(message).bottom),
      );
      await tester.ensureVisible(action);
      await tester.tap(action);
      await tester.pumpAndSettle();
      expect(home, findsOneWidget);
    });
  }
}

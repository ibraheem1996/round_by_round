import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:round_by_round/app/responsive/app_responsive.dart';

void main() {
  test('width and height thresholds are independent and inclusive', () {
    for (final (size, expanded, regular) in [
      (const Size(599, 479), false, false),
      (const Size(600, 480), true, true),
      (const Size(601, 481), true, true),
      (const Size(820, 360), true, false),
      (const Size(390, 840), false, true),
    ]) {
      final window = AppResponsive(size);
      expect(window.byWidth(compact: false, expanded: true), expanded);
      expect(window.byHeight(short: false, regular: true), regular);
    }
  });

  testWidgets('a narrow child reads window changes without a scope', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(840, 360);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 140,
            child: Builder(
              builder: (context) {
                final window = context.responsive;
                final width = window.byWidth(
                  compact: 'compact',
                  expanded: 'expanded',
                );
                final height = window.byHeight(
                  short: 'short',
                  regular: 'regular',
                );
                return Text('$width $height');
              },
            ),
          ),
        ),
      ),
    );
    expect(find.text('expanded short'), findsOneWidget);

    tester.view.physicalSize = const Size(390, 800);
    await tester.pump();
    expect(find.text('compact regular'), findsOneWidget);
  });
}

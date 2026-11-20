import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:round_by_round/shared/widgets/app_safe_area.dart';

import '../../support/mock_device_orientation.dart';

void main() {
  for (final (orientation, portrait, protectLeft, protectRight) in [
    ('PortraitUp', true, true, true),
    ('PortraitDown', true, true, true),
    ('LandscapeLeft', false, true, false),
    ('LandscapeRight', false, false, true),
  ]) {
    testWidgets('protects the correct system edges in $orientation', (
      tester,
    ) async {
      mockDeviceOrientation(orientation);
      final size = portrait ? const Size(360, 640) : const Size(640, 360);
      const systemInsets = EdgeInsets.fromLTRB(32, 24, 20, 16);
      const contentKey = Key('content');
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: size, padding: systemInsets),
          child: const AppSafeArea(child: SizedBox.expand(key: contentKey)),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getRect(find.byKey(contentKey)),
        Rect.fromLTRB(
          protectLeft ? systemInsets.left : 0,
          portrait ? systemInsets.top : 0,
          size.width - (protectRight ? systemInsets.right : 0),
          size.height - systemInsets.bottom,
        ),
      );
    });
  }
}

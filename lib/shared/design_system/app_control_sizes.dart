import 'package:flutter/widgets.dart';

import 'app_window_class.dart';

/// Fixed dimensions for controls and their interactive hit areas.
abstract final class AppControlSizes {
  // static const double small = 32;
  // static const double medium = 40;
  static const double minimumTapTarget = 48;
  static const double compactIconButtonMinSize = 44;
  static const double primaryButtonMinHeight = 56;

  // static const double defaultProgressIndicatorImageSize = 20;

  // Width reserved for leading and action controls in shared chrome.
  // static const double appBarActionLane = minimumTapTarget;

  static double appBarToolbarHeight(BuildContext context) {
    return switch (AppWindowClass.fromContext(context)) {
      AppWindowClass.compact => 56,
      AppWindowClass.medium => 60,
      AppWindowClass.expanded => 64,
    };
  }
}

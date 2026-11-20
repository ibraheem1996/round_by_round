import 'package:flutter/widgets.dart';

/// Describes the width class of the current application window.
///
/// This classification is intentionally independent from device type and the
/// physical display size used by the orientation policy.
enum AppWindowClass {
  compact,
  medium,
  expanded;

  static const double mediumBreakpoint = 600;
  static const double expandedBreakpoint = 840;

  /// Classifies an application window from its logical width.
  static AppWindowClass _fromWidth(double width) {
    if (width < mediumBreakpoint) {
      return compact;
    }
    if (width < expandedBreakpoint) {
      return medium;
    }
    return expanded;
  }

  static AppWindowClass fromContext(BuildContext context) {
    return AppWindowClass._fromWidth(MediaQuery.sizeOf(context).width);
  }
}

/// Whether the current application window needs short-height composition.
///
/// This flag does not affect the width class or the orientation policy.
bool isShortWindow(Size windowSize) => windowSize.height < 480;

import 'package:flutter/widgets.dart';

import 'app_window_class.dart';

/// Selects a value or provides helpers for the current application-window width class.
abstract final class AppResponsiveValue {
  /// Resolves a value for the current window width class (compact, medium, or expanded).
  static T resolve<T>(
    BuildContext context, {
    required T compact,
    required T medium,
    required T expanded,
  }) {
    return switch (AppWindowClass.fromContext(context)) {
      AppWindowClass.compact => compact,
      AppWindowClass.medium => medium,
      AppWindowClass.expanded => expanded,
    };
  }

  /// Checks if the window width is in the compact range (< 600).
  static bool isCompact(BuildContext context) {
    return AppWindowClass.fromContext(context) == AppWindowClass.compact;
  }

  /// Checks if the window width is in the medium range (600 - 840).
  static bool isMedium(BuildContext context) {
    return AppWindowClass.fromContext(context) == AppWindowClass.medium;
  }

  /// Checks if the window width is in the expanded range (>= 840).
  static bool isExpanded(BuildContext context) {
    return AppWindowClass.fromContext(context) == AppWindowClass.expanded;
  }

  /// Checks if the window width is at least medium (>= 600).
  static bool isAtLeastMedium(BuildContext context) {
    return AppWindowClass.fromContext(context) != AppWindowClass.compact;
  }
}

import 'package:flutter/widgets.dart';

import 'app_text_scale_value.dart';
import 'app_window_class.dart';

abstract final class AppIconSizes {
  static double buttonAction(BuildContext context) =>
      _responsive(context, compact: 21, medium: 22, expanded: 23);

  static double compactControl(BuildContext context) => _responsive(
    context,
    compact: _increaseSize(
      context,
      19,
      largeIncrease: 3,
      extraLargeIncrease: 4,
    ),
    medium: _increaseSize(context, 20, largeIncrease: 4, extraLargeIncrease: 5),
    expanded: _increaseSize(
      context,
      21,
      largeIncrease: 6,
      extraLargeIncrease: 7,
    ),
  );

  static double _responsive(
    BuildContext context, {
    required double compact,
    required double medium,
    required double expanded,
  }) {
    return switch (AppWindowClass.fromContext(context)) {
      AppWindowClass.compact => compact,
      AppWindowClass.medium => medium,
      AppWindowClass.expanded => expanded,
    };
  }

  // ignore: unused_element
  static double _increaseSize(
    BuildContext context,
    double size, {
    double? normalIncrease,
    double? largeIncrease,
    double? extraLargeIncrease,
    double fontSize = AppTextScaleValue.defaultBaseFontSize,
  }) {
    return AppTextScaleValue.resolve<double>(
      context,
      fontSize: fontSize,
      normal: size + (normalIncrease ?? 0),
      large: size + (largeIncrease ?? 0),
      extraLarge: size + (extraLargeIncrease ?? 0),
    );
  }
}

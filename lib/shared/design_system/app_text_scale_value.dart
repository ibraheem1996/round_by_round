import 'package:flutter/widgets.dart';

/// Selects a value or provides helpers based on the effective text scale
/// at the provided font size.
abstract final class AppTextScaleValue {
  /// Default base font size used to compute relative text scale.
  static const double defaultBaseFontSize = 14.0;

  /// Resolves a value based on the effective text scale.
  static T resolve<T>(
    BuildContext context, {
    double fontSize = defaultBaseFontSize,
    required T normal,
    required T large,
    required T extraLarge,
  }) {
    final effectiveScale = scaleFactor(context, fontSize: fontSize);

    return switch (effectiveScale) {
      >= 2.0 => extraLarge,
      >= 1.5 => large,
      _ => normal,
    };
  }

  /// Computes the effective text scale factor for the given context and font size.
  static double scaleFactor(
    BuildContext context, {
    double fontSize = defaultBaseFontSize,
  }) {
    final textScaler = MediaQuery.textScalerOf(context);
    return textScaler.scale(fontSize) / fontSize;
  }

  /// Checks if the effective text scale is normal (< 1.5).
  static bool isNormal(
    BuildContext context, {
    double fontSize = defaultBaseFontSize,
  }) {
    return scaleFactor(context, fontSize: fontSize) < 1.5;
  }

  /// Checks if the effective text scale is large or higher (>= 1.5).
  static bool isLargeOrHigher(
    BuildContext context, {
    double fontSize = defaultBaseFontSize,
  }) {
    return scaleFactor(context, fontSize: fontSize) >= 1.5;
  }

  /// Checks if the effective text scale is strictly large (1.5 <= scale < 2.0).
  static bool isLargeOnly(
    BuildContext context, {
    double fontSize = defaultBaseFontSize,
  }) {
    final scale = scaleFactor(context, fontSize: fontSize);
    return scale >= 1.5 && scale < 2.0;
  }

  /// Checks if the effective text scale is extra large (>= 2.0).
  static bool isExtraLarge(
    BuildContext context, {
    double fontSize = defaultBaseFontSize,
  }) {
    return scaleFactor(context, fontSize: fontSize) >= 2.0;
  }
}

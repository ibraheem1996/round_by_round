import 'package:flutter/widgets.dart';

extension AppResponsiveContext on BuildContext {
  /// Resolves values against the app window, independently of parent constraints.
  AppResponsive get responsive => AppResponsive(MediaQuery.sizeOf(this));
}

/// App-wide window policy. Widgets with a local size constraint use that
/// constraint to determine whether their content fits.
final class AppResponsive {
  const AppResponsive(this._window);

  // Initial logical-pixel thresholds to revisit with the composed screens.
  static const double _expandedWidth = 600;
  static const double _regularHeight = 480;

  final Size _window;

  T byWidth<T>({required T compact, required T expanded}) =>
      _window.width < _expandedWidth ? compact : expanded;

  T byHeight<T>({required T short, required T regular}) =>
      _window.height < _regularHeight ? short : regular;
}

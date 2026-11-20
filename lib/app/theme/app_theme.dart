import 'package:material_ui/material_ui.dart';

final lightTheme = _buildAppTheme(ThemeData.light());
final darkTheme = _buildAppTheme(ThemeData.dark());

ThemeData _buildAppTheme(ThemeData defaults) {
  final dark = defaults.brightness == Brightness.dark;
  final scheme = defaults.colorScheme.copyWith(
    primary: const Color(0xFFEA580C),
    onPrimary: const Color(0xFF0E1013),
    surface: dark ? const Color(0xFF0E1013) : const Color(0xFFFAF8F5),
    onSurface: dark ? const Color(0xFFF9FAFB) : const Color(0xFF111827),
    onSurfaceVariant: dark ? const Color(0xFFA3A3A3) : const Color(0xFF4B5563),
  );
  return defaults.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    iconTheme: IconThemeData(applyTextScaling: true),
  );
}

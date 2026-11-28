import 'package:material_ui/material_ui.dart';

import '../../shared/design_system/app_radius.dart';

final lightTheme = _buildAppTheme(ThemeData.light());
final darkTheme = _buildAppTheme(ThemeData.dark());

ThemeData _buildAppTheme(ThemeData defaults) {
  final dark = defaults.brightness == Brightness.dark;
  final scheme = defaults.colorScheme.copyWith(
    primary: const Color(0xFFEA580C),
    onPrimary: const Color(0xFF0E1013),

    surface: dark ? const Color(0xFF0E1013) : const Color(0xFFFAF8F5),
    onSurface: dark ? const Color(0xFFF9FAFB) : const Color(0xFF111827),

    surfaceContainerLow: dark ? const Color(0xFF16181D) : Colors.white,

    surfaceContainer: dark ? const Color(0xFF1E2229) : const Color(0xFFF3F4F6),

    surfaceContainerHigh: dark
        ? const Color(0xFF262B34)
        : const Color(0xFFEDEFF2),

    outlineVariant: dark ? const Color(0xFF262930) : const Color(0xFFE5E7EB),

    onSurfaceVariant: dark ? const Color(0xFFA3A3A3) : const Color(0xFF4B5563),
  );
  return defaults.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    cardTheme: defaults.cardTheme.copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(AppRadius.cardRadius),
        ),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      color: scheme.surfaceContainerLow,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    iconTheme: IconThemeData(applyTextScaling: true),
  );
}

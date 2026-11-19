import 'package:material_ui/material_ui.dart';

extension AppTypographyContext on BuildContext {
  AppTypography get appTypography => AppTypography._(this);
}

/// Resolves semantic roles from the active, localized Flutter theme.
/// Flutter applies the platform's text scaler when it lays out the text.
final class AppTypography {
  AppTypography._(BuildContext context)
    : _theme = Theme.of(context),
      _isArabic = Localizations.localeOf(context).languageCode == 'ar';

  final ThemeData _theme;
  final bool _isArabic;

  TextStyle get pageTitle => _theme.textTheme.headlineLarge!.copyWith(
    fontWeight: FontWeight.w800,
    height: _isArabic ? 1.3 : 1.14,
    color: _theme.colorScheme.onSurface,
  );

  TextStyle get supportingBody => _theme.textTheme.bodyLarge!.copyWith(
    height: _isArabic ? 1.6 : 1.45,
    color: _theme.colorScheme.onSurfaceVariant,
  );

  TextStyle get buttonLabel => _theme.textTheme.labelLarge!.copyWith(
    fontWeight: FontWeight.w700,
    height: _isArabic ? 1.35 : 1.2,
  );
}

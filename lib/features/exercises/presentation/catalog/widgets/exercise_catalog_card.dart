import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../../app/theme/app_typography.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/app_aspect_ratios.dart';
import '../../../../../shared/design_system/app_radius.dart';
import '../../../../../shared/design_system/app_responsive_value.dart';
import '../../../../../shared/design_system/app_spacing.dart';
import '../../../../../shared/design_system/app_text_scale_limits.dart';
import '../../../../../shared/design_system/app_text_scale_value.dart';
import '../../../domain/exercise_definition.dart';
import '../exercise_catalog_labels.dart';

class ExerciseCatalogCard extends StatelessWidget {
  const ExerciseCatalogCard({
    required this.exercise,
    required this.onTap,
    super.key,
  });
  final ExerciseDefinition exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final name = exercise.displayName(
      Localizations.localeOf(context).languageCode,
    );
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: AppTextScaleLimits.contentCard,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.relatedItemGap),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final preferredWidth = AppResponsiveValue.resolve(
                  context,
                  compact: 88.0,
                  medium: 96.0,
                  expanded: 104.0,
                );
                final textScaleIncrease = AppTextScaleValue.resolve(
                  context,
                  normal: 0.0,
                  large: 5.0,
                  extraLarge: 7.0,
                );
                final thumbnailWidth = math.min(
                  preferredWidth + textScaleIncrease,
                  constraints.maxWidth / 3,
                );

                return Row(
                  children: [
                    _ExerciseThumbnail(
                      imageRef: exercise.imageRef,
                      width: thumbnailWidth,
                    ),
                    const SizedBox(width: AppSpacing.titleToBodyGap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.compactItemGap,
                        children: [
                          Text(
                            name,
                            style: context.appTypography.catalogCardTitle,
                          ),
                          Wrap(
                            spacing: AppSpacing.relatedItemGap,
                            runSpacing: AppSpacing.compactItemGap,
                            children: [
                              _CardLabel(groupLabel(l, exercise.group)),
                              if (exercise.equipment case final value?)
                                _CardLabel(equipmentLabel(l, value)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.chevron_left
                          : Icons.chevron_right,
                      color: colors.onSurfaceVariant,
                      applyTextScaling: false,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: const BorderRadius.all(
        Radius.circular(AppRadius.badgeRadius),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.badgeHorizontalPadding,
        vertical: AppSpacing.badgeVerticalPadding,
      ),
      child: Text(
        label,
        style: context.appTypography.catalogCardLabel.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    ),
  );
}

class _ExerciseThumbnail extends StatelessWidget {
  const _ExerciseThumbnail({required this.imageRef, required this.width});

  final String? imageRef;
  final double width;

  @override
  Widget build(BuildContext context) {
    const placeholder = Center(child: Icon(Icons.image_outlined));
    final asset = imageRef;

    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(AppRadius.thumbnailRadius),
      ),
      child: SizedBox(
        width: width,
        child: AspectRatio(
          aspectRatio: AppAspectRatios.cardThumbnail,
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: asset == null || width == 0
                ? placeholder
                : Image.asset(
                    asset,
                    excludeFromSemantics: true,
                    fit: BoxFit.cover,
                    cacheWidth: (width * MediaQuery.devicePixelRatioOf(context))
                        .ceil(),
                    errorBuilder: (_, _, _) => placeholder,
                  ),
          ),
        ),
      ),
    );
  }
}

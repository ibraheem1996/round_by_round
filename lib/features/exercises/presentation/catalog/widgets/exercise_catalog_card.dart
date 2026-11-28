import 'package:material_ui/material_ui.dart';

import '../../../../../app/theme/app_typography.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/app_radius.dart';
import '../../../../../shared/design_system/app_spacing.dart';
import '../../../../../shared/design_system/app_text_scale_limits.dart';
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
            child: Row(
              children: [
                _ExerciseThumbnail(imageRef: exercise.imageRef),
                const SizedBox(width: AppSpacing.relatedItemGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.compactItemGap,
                    children: [
                      Text(name, style: context.appTypography.catalogCardTitle),
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
                ),
              ],
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
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: const BorderRadius.all(
        Radius.circular(AppRadius.badgeRadius),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.badgeHorizontalPadding,
        vertical: AppSpacing.badgeVerticalPadding,
      ),
      child: Text(label, style: context.appTypography.catalogCardLabel),
    ),
  );
}

class _ExerciseThumbnail extends StatelessWidget {
  const _ExerciseThumbnail({required this.imageRef});

  final String? imageRef;

  @override
  Widget build(BuildContext context) {
    const width = 88.0;
    const height = 72.0;
    const placeholder = Center(child: Icon(Icons.image_outlined));
    final asset = imageRef;

    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(AppRadius.thumbnailRadius),
      ),
      child: Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: asset == null
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
    );
  }
}

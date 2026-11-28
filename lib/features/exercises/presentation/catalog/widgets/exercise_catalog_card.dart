import 'package:material_ui/material_ui.dart';

import '../../../../../app/theme/app_typography.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/app_spacing.dart';
import '../../../domain/exercise_catalog_repository.dart';
import '../../../domain/exercise_definition.dart';
import '../exercise_catalog_labels.dart';

class ExerciseCatalogCard extends StatelessWidget {
  const ExerciseCatalogCard({
    required this.exercise,
    required this.repository,
    required this.onTap,
    super.key,
  });
  final ExerciseDefinition exercise;
  final VoidCallback onTap;
  final ExerciseCatalogRepository repository;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final name = exercise.displayName(
      Localizations.localeOf(context).languageCode,
    );
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.relatedItemGap),
          child: Row(
            children: [
              _ExerciseThumbnail(
                repository: repository,
                exerciseId: exercise.exerciseId,
              ),
              const SizedBox(width: AppSpacing.relatedItemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(name, style: context.appTypography.catalogCardTitle),
                    Wrap(
                      spacing: AppSpacing.relatedItemGap,
                      runSpacing: 4,
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
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(label, style: context.appTypography.catalogCardLabel),
    ),
  );
}

class _ExerciseThumbnail extends StatefulWidget {
  const _ExerciseThumbnail({
    required this.repository,
    required this.exerciseId,
    this.candidate = 0,
    super.key,
  });

  final ExerciseCatalogRepository repository;
  final String exerciseId;
  final int candidate;

  @override
  State<_ExerciseThumbnail> createState() => _ExerciseThumbnailState();
}

class _ExerciseThumbnailState extends State<_ExerciseThumbnail> {
  late final _bytes = widget.repository.loadImage(
    widget.exerciseId,
    candidate: widget.candidate,
  );

  @override
  Widget build(BuildContext context) {
    const width = 88.0;
    const height = 72.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: FutureBuilder(
          future: _bytes,
          builder: (context, snapshot) {
            final bytes = snapshot.data;
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox.shrink();
            }
            if (snapshot.hasError || bytes == null) {
              return const Icon(Icons.image_outlined);
            }
            Widget nextCandidate() => _ExerciseThumbnail(
              key: ValueKey(widget.candidate + 1),
              repository: widget.repository,
              exerciseId: widget.exerciseId,
              candidate: widget.candidate + 1,
            );
            if (bytes.isEmpty) return nextCandidate();
            return Image.memory(
              bytes,
              excludeFromSemantics: true,
              fit: BoxFit.cover,
              cacheWidth: (width * MediaQuery.devicePixelRatioOf(context))
                  .ceil(),
              errorBuilder: (_, _, _) => nextCandidate(),
            );
          },
        ),
      ),
    );
  }
}

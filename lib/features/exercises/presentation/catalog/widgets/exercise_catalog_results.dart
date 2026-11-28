import 'package:material_ui/material_ui.dart';

import '../../../../../app/theme/app_typography.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/app_spacing.dart';
import '../../../domain/exercise_catalog_repository.dart';
import '../exercise_catalog_cubit.dart';
import '../exercise_catalog_labels.dart';
import 'exercise_catalog_card.dart';

class ExerciseCatalogResults extends StatelessWidget {
  const ExerciseCatalogResults({
    required this.state,
    required this.repository,
    required this.onRetry,
    required this.onExercisePressed,
    super.key,
  });

  final ExerciseCatalogState state;
  final ExerciseCatalogRepository repository;
  final VoidCallback onRetry;
  final ValueChanged<String> onExercisePressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    if (state.loading) {
      return _fill(const CircularProgressIndicator.adaptive());
    }
    if (state.failed) {
      return _fill(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.exerciseLoadFailed),
            TextButton(onPressed: onRetry, child: Text(l.exerciseRetry)),
          ],
        ),
      );
    }

    final results = state.results;
    if (results.isEmpty) return _fill(Text(l.noMatchingExercises));

    return SliverList.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final exercise = results[index];
        final group = exercise.group;
        final startsGroup =
            state.grouped && (index == 0 || results[index - 1].group != group);

        return Column(
          key: ValueKey(exercise.exerciseId),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (startsGroup)
              Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.sectionGap,
                  bottom: AppSpacing.relatedItemGap,
                ),
                child: Text(
                  groupLabel(l, group),
                  style: context.appTypography.catalogSectionTitle,
                ),
              ),
            ExerciseCatalogCard(
              exercise: exercise,
              repository: repository,
              onTap: () => onExercisePressed(exercise.exerciseId),
            ),
          ],
        );
      },
    );
  }

  Widget _fill(Widget child) =>
      SliverFillRemaining(hasScrollBody: false, child: Center(child: child));
}

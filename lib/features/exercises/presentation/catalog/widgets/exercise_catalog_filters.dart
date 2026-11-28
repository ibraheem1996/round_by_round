import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../app/theme/app_typography.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/app_spacing.dart';
import '../../../domain/exercise_definition.dart';
import '../exercise_catalog_cubit.dart';
import '../exercise_catalog_labels.dart';
import 'exercise_catalog_filter_sheet.dart';

class ExerciseCatalogFilters extends StatelessWidget {
  const ExerciseCatalogFilters({required this.state, super.key});

  final ExerciseCatalogState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final cubit = context.read<ExerciseCatalogCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.relatedItemGap,
      children: [
        Row(
          children: [
            Expanded(
              child: _FilterButton(
                label: l.exerciseMuscles,
                compactLabel: l.exerciseMusclesCount(state.groups.length),
                selections: state.groups.map((value) => groupLabel(l, value)),
                icon: Icons.accessibility_new,
                onPressed: () => showExerciseCatalogFilter(
                  context,
                  title: l.exerciseMuscles,
                  options: ExerciseGroup.values,
                  label: (value) => groupLabel(l, value),
                  selected: (state) => state.groups,
                  toggle: cubit.toggleGroup,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.relatedItemGap),
            Expanded(
              child: _FilterButton(
                label: l.exerciseEquipment,
                compactLabel: l.exerciseEquipmentCount(state.equipment.length),
                selections: state.equipment.map(
                  (value) => equipmentLabel(l, value),
                ),
                icon: Icons.fitness_center,
                onPressed: () => showExerciseCatalogFilter(
                  context,
                  title: l.exerciseEquipment,
                  options: Equipment.values,
                  label: (value) => equipmentLabel(l, value),
                  selected: (state) => state.equipment,
                  toggle: cubit.toggleEquipment,
                ),
              ),
            ),
          ],
        ),
        if (state.groups.isNotEmpty || state.equipment.isNotEmpty)
          Wrap(
            spacing: AppSpacing.relatedItemGap,
            children: [
              for (final value in state.groups)
                InputChip(
                  label: Text(groupLabel(l, value)),
                  onDeleted: () => cubit.toggleGroup(value),
                ),
              for (final value in state.equipment)
                InputChip(
                  label: Text(equipmentLabel(l, value)),
                  onDeleted: () => cubit.toggleEquipment(value),
                ),
            ],
          ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.compactLabel,
    required this.selections,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String compactLabel;
  final Iterable<String> selections;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final style = context.appTypography.buttonLabel;
    final colors = Theme.of(context).colorScheme;
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        textStyle: style,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.all(AppSpacing.relatedItemGap),
        backgroundColor: colors.surfaceContainerHigh,
      ),
      onPressed: onPressed,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final names = selections.isEmpty
              ? label
              : selections.join(
                  Directionality.of(context) == TextDirection.rtl ? '، ' : ', ',
                );
          final painter =
              TextPainter(
                text: TextSpan(text: names, style: style),
                textScaler: MediaQuery.textScalerOf(context),
                textDirection: Directionality.of(context),
                maxLines: 1,
              )..layout(
                maxWidth: (constraints.maxWidth - 48).clamp(
                  0.0,
                  double.infinity,
                ),
              );
          final showNames = !painter.didExceedMaxLines;
          painter.dispose();
          return Row(
            children: [
              if (constraints.maxWidth >= 100) ...[
                Icon(icon, size: 18, color: colors.primary),
                const SizedBox(width: AppSpacing.relatedItemGap),
              ],
              Expanded(
                child: Text(
                  showNames || selections.isEmpty ? names : compactLabel,
                ),
              ),
              if (constraints.maxWidth >= 100)
                const Icon(Icons.arrow_drop_down, size: 18),
            ],
          );
        },
      ),
    );
  }
}

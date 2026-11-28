import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../app/theme/app_typography.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/app_spacing.dart';
import '../exercise_catalog_cubit.dart';
import 'exercise_catalog_filters.dart';

class ExerciseCatalogHeader extends StatefulWidget {
  const ExerciseCatalogHeader({super.key});

  @override
  State<ExerciseCatalogHeader> createState() => _ExerciseCatalogHeaderState();
}

class _ExerciseCatalogHeaderState extends State<ExerciseCatalogHeader> {
  late final _search = TextEditingController(
    text: context.read<ExerciseCatalogCubit>().state.search,
  );

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final cubit = context.read<ExerciseCatalogCubit>();
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<ExerciseCatalogCubit, ExerciseCatalogState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.relatedItemGap,
        children: [
          Text(l.allExercises, style: context.appTypography.pageTitle),
          TextField(
            controller: _search,
            onChanged: cubit.search,
            decoration: InputDecoration(
              labelText: l.searchExercises,
              filled: true,
              fillColor: colors.surfaceContainer,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: state.search.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l.clearExerciseSearch,
                      onPressed: () {
                        _search.clear();
                        cubit.search('');
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
          ExerciseCatalogFilters(state: state),
          if (!state.loading && !state.failed)
            Text(
              l.exerciseResults(state.results.length),
              style: context.appTypography.supportingBody,
            ),
        ],
      ),
    );
  }
}

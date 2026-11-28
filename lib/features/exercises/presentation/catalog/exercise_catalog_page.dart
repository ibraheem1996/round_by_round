import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_frame.dart';
import 'exercise_catalog_cubit.dart';
import 'widgets/exercise_catalog_header.dart';
import 'widgets/exercise_catalog_results.dart';

class ExerciseCatalogPage extends StatelessWidget {
  const ExerciseCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.exerciseLibrary)),
      body: const AppPageFrame(
        child: CustomScrollView(
          key: PageStorageKey('exercise-catalog'),
          slivers: [
            SliverToBoxAdapter(child: ExerciseCatalogHeader()),
            _CatalogResults(),
          ],
        ),
      ),
    );
  }
}

class _CatalogResults extends StatelessWidget {
  const _CatalogResults();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExerciseCatalogCubit>();

    return BlocBuilder<ExerciseCatalogCubit, ExerciseCatalogState>(
      builder: (context, state) => ExerciseCatalogResults(
        state: state,
        repository: cubit.repository,
        onRetry: cubit.load,
        onExercisePressed: (id) => context.pushNamed(
          'exercise-details',
          pathParameters: {'exerciseId': id},
        ),
      ),
    );
  }
}

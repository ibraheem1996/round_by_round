import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../app/theme/app_typography.dart';
import '../../../../../shared/design_system/app_spacing.dart';
import '../../../../../shared/design_system/app_text_scale_limits.dart';
import '../exercise_catalog_cubit.dart';

void showExerciseCatalogFilter<T>(
  BuildContext context, {
  required String title,
  required List<T> options,
  required String Function(T) label,
  required Set<T> Function(ExerciseCatalogState) selected,
  required void Function(T) toggle,
}) {
  final cubit = context.read<ExerciseCatalogCubit>();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) =>
        BlocBuilder<ExerciseCatalogCubit, ExerciseCatalogState>(
          bloc: cubit,
          builder: (context, state) => MediaQuery.withClampedTextScaling(
            maxScaleFactor: AppTextScaleLimits.bottomSheet,
            child: FractionallySizedBox(
              heightFactor: .8,
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontalInset,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: context.appTypography.catalogSectionTitle,
                            ),
                          ),
                          CloseButton(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final value = options[index];
                          return CheckboxListTile(
                            title: Text(label(value)),
                            value: selected(state).contains(value),
                            onChanged: (_) => toggle(value),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
  );
}

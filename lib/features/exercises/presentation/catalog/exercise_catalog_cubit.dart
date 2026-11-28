import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/exercise_catalog_query.dart';
import '../../domain/exercise_catalog_repository.dart';
import '../../domain/exercise_definition.dart';

part 'exercise_catalog_cubit.freezed.dart';

@freezed
abstract class ExerciseCatalogState with _$ExerciseCatalogState {
  const ExerciseCatalogState._();
  const factory ExerciseCatalogState({
    @Default(true) bool loading,
    @Default(false) bool failed,
    @Default('') String search,
    @Default({}) Set<ExerciseGroup> groups,
    @Default({}) Set<Equipment> equipment,
    @Default([]) List<ExerciseDefinition> results,
  }) = _ExerciseCatalogState;

  bool get grouped =>
      search.trim().isEmpty && groups.isEmpty && equipment.isEmpty;
}

@injectable
class ExerciseCatalogCubit extends Cubit<ExerciseCatalogState> {
  ExerciseCatalogCubit(this.repository) : super(const ExerciseCatalogState());

  final ExerciseCatalogRepository repository;
  List<ExerciseDefinition> _definitions = const [];

  Future<void> load() async {
    emit(state.copyWith(loading: true, failed: false));
    try {
      _definitions = await repository.loadAll();
      if (!isClosed) _update(state.copyWith(loading: false));
    } on Object {
      if (!isClosed) emit(state.copyWith(loading: false, failed: true));
    }
  }

  void search(String text) => _update(state.copyWith(search: text));

  void toggleGroup(ExerciseGroup value) {
    final selected = {...state.groups};
    if (!selected.remove(value)) selected.add(value);
    _update(state.copyWith(groups: selected));
  }

  void toggleEquipment(Equipment value) {
    final selected = {...state.equipment};
    if (!selected.remove(value)) selected.add(value);
    _update(state.copyWith(equipment: selected));
  }

  void _update(ExerciseCatalogState next) => emit(
    next.copyWith(
      results: queryCatalog(
        _definitions,
        search: next.search,
        groups: next.groups,
        equipment: next.equipment,
      ),
    ),
  );
}

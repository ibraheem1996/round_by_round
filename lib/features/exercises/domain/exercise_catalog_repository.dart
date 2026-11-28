import 'exercise_definition.dart';

abstract interface class ExerciseCatalogRepository {
  Future<List<ExerciseDefinition>> loadAll();
}

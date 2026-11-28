import 'dart:typed_data';

import 'exercise_definition.dart';

abstract interface class ExerciseCatalogRepository {
  Future<List<ExerciseDefinition>> loadAll();

  /// Reads a card image candidate on demand. Null means no more candidates.
  Future<Uint8List?> loadImage(String exerciseId, {int candidate = 0});
}

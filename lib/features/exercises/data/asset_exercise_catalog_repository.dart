import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../domain/exercise_catalog_repository.dart';
import '../domain/exercise_definition.dart';
import 'dto/asset_exercise_catalog_dto.dart';

@LazySingleton(as: ExerciseCatalogRepository)
class AssetExerciseCatalogRepository implements ExerciseCatalogRepository {
  static const _root = 'assets/exercise_library';
  List<ExerciseDefinition>? _definitions;

  @override
  Future<List<ExerciseDefinition>> loadAll() async {
    if (_definitions case final definitions?) return definitions;
    final text = await rootBundle.loadString('$_root/catalog.json');
    final json = jsonDecode(text);
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Expected an exercise catalog object');
    }

    final catalog = AssetExerciseCatalogDto.fromJson(json);
    final definitions = <ExerciseDefinition>[];
    final exerciseIds = <String>{};

    for (final exercise in catalog.exercises) {
      final id = exercise.exerciseId;
      if (!exerciseIds.add(id)) {
        throw FormatException('Duplicate exercise ID: $id');
      }
      definitions.add(exercise.toDefinition(assetRoot: _root));
    }

    return _definitions = List.unmodifiable(definitions);
  }
}

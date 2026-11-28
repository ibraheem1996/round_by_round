import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../domain/exercise_catalog_repository.dart';
import '../domain/exercise_definition.dart';
import 'dto/asset_exercise_catalog_dto.dart';

@LazySingleton(as: ExerciseCatalogRepository)
class AssetExerciseCatalogRepository implements ExerciseCatalogRepository {
  static const _root = 'assets/exercise_library';
  final _images = <String, List<String>>{};
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
    final images = <String, List<String>>{};

    for (final exercise in catalog.exercises) {
      final id = exercise.exerciseId;
      if (images.containsKey(id)) {
        throw FormatException('Duplicate exercise ID: $id');
      }
      definitions.add(exercise.toDefinition());
      images[id] = exercise.imageCandidates;
    }

    _images.addAll(images);
    return _definitions = List.unmodifiable(definitions);
  }

  @override
  Future<Uint8List?> loadImage(String exerciseId, {int candidate = 0}) async {
    final paths = _images[exerciseId] ?? const [];
    if (candidate >= paths.length) return null;
    try {
      final data = await rootBundle.load('$_root/${paths[candidate]}');
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } on FlutterError {
      // An empty candidate can be skipped while preserving the next index.
      return Uint8List(0);
    }
  }
}

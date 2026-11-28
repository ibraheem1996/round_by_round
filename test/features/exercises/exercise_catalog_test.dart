import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:round_by_round/features/exercises/data/asset_exercise_catalog_repository.dart';
import 'package:round_by_round/features/exercises/domain/exercise_catalog_query.dart';
import 'package:round_by_round/features/exercises/domain/exercise_definition.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repository = AssetExerciseCatalogRepository();
  late List<ExerciseDefinition> catalog;

  setUpAll(() async => catalog = await repository.loadAll());

  test('reads the tracked V4 catalog and preserves exercise identities', () {
    final asset = File('assets/exercise_library/catalog.json');
    final source = jsonDecode(asset.readAsStringSync()) as Map;
    final rows = (source['exercises'] as List).cast<Map>();
    expect(catalog, hasLength(210));
    expect(catalog.map((e) => e.exerciseId), rows.map((e) => e['exerciseId']));
    expect(catalog.map((e) => e.exerciseId).toSet(), hasLength(210));
    expect(
      catalog.map((e) => e.imageRef),
      rows.map((e) => 'assets/exercise_library/${e['imageRef']}'),
    );
    final strength = catalog.where(
      (e) => e.activity == ExerciseActivity.strength,
    );
    final cardio = catalog.where((e) => e.activity == ExerciseActivity.cardio);
    expect(strength, hasLength(196));
    expect(strength.every((e) => e.group != ExerciseGroup.cardio), isTrue);
    expect(strength.map((e) => e.trackingType).toSet(), hasLength(5));
    expect(cardio, hasLength(14));
    expect(cardio.every((e) => e.group == ExerciseGroup.cardio), isTrue);
    expect(
      cardio.where((e) => e.trackingType == ExerciseTrackingType.duration),
      hasLength(9),
    );
    expect(
      cardio
          .where((e) => e.trackingType == ExerciseTrackingType.durationDistance)
          .map((e) => e.exerciseId),
      unorderedEquals([
        'builtin:air_bike',
        'builtin:elliptical',
        'builtin:exercise_bike',
        'builtin:rowing_machine',
        'builtin:treadmill_run',
      ]),
    );
    expect(catalog.map((e) => e.equipment).toSet(), hasLength(7));
    final paths = <String>{
      for (final row in rows) ...[
        if (row['imageRef'] case final String path) path,
        for (final frame in row['frames'] as List) frame['path'] as String,
      ],
    };
    expect(paths, hasLength(399));
    for (final path in paths) {
      expect(
        File('assets/exercise_library/$path').existsSync(),
        isTrue,
        reason: path,
      );
    }
  });

  test('the legs group includes every leg muscle from the source catalog', () {
    final results = queryCatalog(catalog, groups: {ExerciseGroup.legs});
    expect(results, hasLength(67));
    expect(
      results.every((exercise) => exercise.group == ExerciseGroup.legs),
      isTrue,
    );
  });

  test(
    'matches both languages, aliases and normalized Arabic with unique results',
    () {
      final id = catalog.first.exerciseId;
      for (final query in ['FLAT BENCH PRESS', 'بِنْش   بَار', 'ضغط صدر']) {
        final results = queryCatalog(catalog, search: query);
        expect(
          results.map((e) => e.exerciseId).where((e) => e == id),
          hasLength(1),
        );
      }
      for (final query in ['ظهر', 'ضهر']) {
        expect(
          queryCatalog(catalog, search: query).map((e) => e.exerciseId),
          contains('builtin:back_extensions'),
        );
      }
    },
  );

  test('combines OR within filters and AND across filters and search', () {
    final results = queryCatalog(
      catalog,
      groups: {ExerciseGroup.chest, ExerciseGroup.cardio},
      equipment: {Equipment.machines, Equipment.dumbbell},
    );
    expect(results.any((e) => e.group == ExerciseGroup.chest), isTrue);
    expect(results.any((e) => e.exerciseId == 'builtin:treadmill_run'), isTrue);
    expect(
      results.every(
        (e) =>
            {Equipment.machines, Equipment.dumbbell}.contains(e.equipment) &&
            (e.group == ExerciseGroup.chest ||
                e.activity == ExerciseActivity.cardio),
      ),
      isTrue,
    );
    expect(
      queryCatalog(results, search: 'treadmill').map((e) => e.exerciseId),
      ['builtin:treadmill_run'],
    );
    expect(
      results.map((e) => e.exerciseId),
      isNot(contains('builtin:jump_rope')),
    );
  });

  test(
    'groups all definitions and sorts by V4 priority regardless of JSON order',
    () {
      final results = queryCatalog(catalog.reversed);
      expect(results.first.exerciseId, 'builtin:barbell_bench_press');
      expect(
        results.map((e) => e.group).toSet(),
        orderedEquals(ExerciseGroup.values),
      );
      expect(
        results.skip(196).every((e) => e.activity == ExerciseActivity.cardio),
        isTrue,
      );
      for (final group in ExerciseGroup.values) {
        final ranks = results
            .where((e) => e.group == group)
            .map((e) => e.sortOrder);
        expect(ranks, orderedEquals(ranks.toList()..sort()));
      }
      final entry = results[1];
      expect(
        queryCatalog([entry.copyWith(sortOrder: -1), ...catalog])
            .first
            .exerciseId,
        entry.exerciseId,
      );
    },
  );
}

import 'exercise_definition.dart';

final _diacritics = RegExp(r'[\u064B-\u065F\u0670\u0640]');
final _alef = RegExp('[أإآٱ]');
final _yeh = RegExp('[ىی]');
final _spaces = RegExp(r'\s+');

String _normalize(String text) => text
    .toLowerCase()
    .replaceAll(_diacritics, '')
    .replaceAll(_alef, 'ا')
    .replaceAll(_yeh, 'ي')
    .trim()
    .replaceAll(_spaces, ' ');
List<ExerciseDefinition> queryCatalog(
  Iterable<ExerciseDefinition> definitions, {
  String search = '',
  Set<ExerciseGroup> groups = const {},
  Set<Equipment> equipment = const {},
}) {
  final query = _normalize(search);

  final groupResults = query.isEmpty && groups.isEmpty && equipment.isEmpty;

  final matches = <({ExerciseDefinition exercise, int priority})>[];

  final seenIds = <String>{};

  for (final exercise in definitions) {
    // 1. Group filter
    if (groups.isNotEmpty && !groups.contains(exercise.group)) {
      continue;
    }

    // 2. Equipment filter
    final exerciseEquipment = exercise.equipment;

    if (equipment.isNotEmpty &&
        exerciseEquipment != null &&
        !equipment.contains(exerciseEquipment)) {
      continue;
    }

    // 3. Search
    final searchRank = query.isEmpty ? 0 : _matchRank(exercise, query);

    if (searchRank == null) {
      continue;
    }

    // 4. Skip duplicates
    if (!seenIds.add(exercise.exerciseId)) {
      continue;
    }

    // 5. Calculate priority
    final priority = groupResults ? exercise.group.index : searchRank;

    matches.add((exercise: exercise, priority: priority));
  }

  // 6. Sort results
  matches.sort((a, b) {
    final byPriority = a.priority.compareTo(b.priority);

    if (byPriority != 0) return byPriority;

    final bySortOrder = a.exercise.sortOrder.compareTo(b.exercise.sortOrder);

    if (bySortOrder != 0) return bySortOrder;

    return a.exercise.exerciseId.compareTo(b.exercise.exerciseId);
  });

  // 7. Return exercises only
  return matches.map((match) => match.exercise).toList();
}

int? _matchRank(ExerciseDefinition exercise, String query) {
  final names = [
    if (exercise.nameAr case final name?) _normalize(name),
    if (exercise.nameEn case final name?) _normalize(name),
  ];
  if (names.contains(query)) return 0;
  if (names.any((name) => name.startsWith(query))) return 1;
  if (names.any((name) => name.contains(query)) ||
      exercise.aliases.any((name) => _normalize(name).contains(query))) {
    return 2;
  }
  return null;
}

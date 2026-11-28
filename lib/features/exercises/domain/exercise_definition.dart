import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_definition.freezed.dart';

enum ExerciseSource { builtIn, custom }

enum ExerciseActivity { strength, cardio }

enum ExerciseTrackingType {
  weightReps,
  repsOnly,
  bodyweightAddedReps,
  assistedReps,
  durationOptionalWeight,
  duration,
  durationDistance,
}

enum ExerciseGroup {
  chest,
  back,
  legs,
  biceps,
  triceps,
  shoulders,
  other,
  cardio,
}

enum Equipment {
  machines,
  noEquipment,
  dumbbell,
  barbell,
  resistanceBand,
  kettlebell,
  other,
}

@freezed
abstract class ExerciseDefinition with _$ExerciseDefinition {
  const ExerciseDefinition._();

  const factory ExerciseDefinition({
    required String exerciseId,
    required ExerciseSource source,
    String? nameAr,
    String? nameEn,
    required List<String> aliases,
    required ExerciseActivity activity,
    required ExerciseTrackingType trackingType,
    required ExerciseGroup group,
    Equipment? equipment,
    required int sortOrder,
  }) = _ExerciseDefinition;

  String displayName(String languageCode) =>
      (languageCode == 'ar' ? nameAr ?? nameEn : nameEn ?? nameAr) ??
      exerciseId;
}

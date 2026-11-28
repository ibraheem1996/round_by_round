// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_exercise_catalog_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetExerciseCatalogDto _$AssetExerciseCatalogDtoFromJson(
  Map<String, dynamic> json,
) => AssetExerciseCatalogDto(
  exercises: (json['exercises'] as List<dynamic>)
      .map((e) => AssetExerciseDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

AssetExerciseDto _$AssetExerciseDtoFromJson(Map<String, dynamic> json) =>
    AssetExerciseDto(
      exerciseId: json['exerciseId'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      aliases: AssetExerciseAliasesDto.fromJson(
        json['aliases'] as Map<String, dynamic>,
      ),
      activity: $enumDecode(_$ExerciseActivityEnumMap, json['activity']),
      trackingType: $enumDecode(
        _$ExerciseTrackingTypeEnumMap,
        json['trackingType'],
      ),
      equipment: $enumDecode(_$EquipmentEnumMap, json['equipment']),
      sortOrder: (json['sortOrder'] as num).toInt(),
      primaryMuscle: json['primaryMuscle'] as String?,
      imageRef: json['imageRef'] as String?,
    );

const _$ExerciseActivityEnumMap = {
  ExerciseActivity.strength: 'strength',
  ExerciseActivity.cardio: 'cardio',
};

const _$ExerciseTrackingTypeEnumMap = {
  ExerciseTrackingType.weightReps: 'weightReps',
  ExerciseTrackingType.repsOnly: 'repsOnly',
  ExerciseTrackingType.bodyweightAddedReps: 'bodyweightAddedReps',
  ExerciseTrackingType.assistedReps: 'assistedReps',
  ExerciseTrackingType.durationOptionalWeight: 'durationOptionalWeight',
  ExerciseTrackingType.duration: 'duration',
  ExerciseTrackingType.durationDistance: 'durationDistance',
};

const _$EquipmentEnumMap = {
  Equipment.machines: 'machines',
  Equipment.noEquipment: 'noEquipment',
  Equipment.dumbbell: 'dumbbell',
  Equipment.barbell: 'barbell',
  Equipment.resistanceBand: 'resistanceBand',
  Equipment.kettlebell: 'kettlebell',
  Equipment.other: 'other',
};

AssetExerciseAliasesDto _$AssetExerciseAliasesDtoFromJson(
  Map<String, dynamic> json,
) => AssetExerciseAliasesDto(
  ar: (json['ar'] as List<dynamic>).map((e) => e as String).toList(),
  en: (json['en'] as List<dynamic>).map((e) => e as String).toList(),
);

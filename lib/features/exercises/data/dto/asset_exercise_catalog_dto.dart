import 'package:json_annotation/json_annotation.dart';

import '../../domain/exercise_definition.dart';

part 'asset_exercise_catalog_dto.g.dart';

@JsonSerializable(createToJson: false)
class AssetExerciseCatalogDto {
  const AssetExerciseCatalogDto({required this.exercises});

  factory AssetExerciseCatalogDto.fromJson(Map<String, dynamic> json) =>
      _$AssetExerciseCatalogDtoFromJson(json);

  final List<AssetExerciseDto> exercises;
}

@JsonSerializable(createToJson: false)
class AssetExerciseDto {
  const AssetExerciseDto({
    required this.exerciseId,
    required this.nameAr,
    required this.nameEn,
    required this.aliases,
    required this.activity,
    required this.trackingType,
    required this.equipment,
    required this.sortOrder,
    this.primaryMuscle,
    this.imageRef,
    this.frames = const [],
  });

  factory AssetExerciseDto.fromJson(Map<String, dynamic> json) =>
      _$AssetExerciseDtoFromJson(json);

  final String exerciseId;
  final String nameAr;
  final String nameEn;
  final AssetExerciseAliasesDto aliases;
  final ExerciseActivity activity;
  final ExerciseTrackingType trackingType;
  final String? primaryMuscle;
  final Equipment equipment;
  final int sortOrder;
  final String? imageRef;
  final List<AssetExerciseFrameDto> frames;

  List<String> get imageCandidates {
    final paths = <String>{};

    final image = imageRef;

    if (image != null) {
      paths.add(image);
    }

    for (final frame in frames) {
      final path = frame.path;

      if (path != null) {
        paths.add(path);
      }
    }

    return paths.toList();
  }

  ExerciseDefinition toDefinition() {
    final isCardio = activity == ExerciseActivity.cardio;
    final hasCardioTracking =
        trackingType == ExerciseTrackingType.duration ||
        trackingType == ExerciseTrackingType.durationDistance;

    if (exerciseId.trim().isEmpty ||
        nameAr.trim().isEmpty ||
        nameEn.trim().isEmpty ||
        isCardio != (primaryMuscle == null) ||
        isCardio != hasCardioTracking) {
      throw FormatException('Invalid exercise definition: $exerciseId');
    }

    return ExerciseDefinition(
      exerciseId: exerciseId,
      source: ExerciseSource.builtIn,
      nameAr: nameAr,
      nameEn: nameEn,
      aliases: [...aliases.ar, ...aliases.en],
      activity: activity,
      trackingType: trackingType,
      group: _readGroup(),
      equipment: equipment,
      sortOrder: sortOrder,
    );
  }

  ExerciseGroup _readGroup() => switch (primaryMuscle) {
    null => ExerciseGroup.cardio,
    'chest' => ExerciseGroup.chest,
    'back' || 'traps' || 'lowerBack' => ExerciseGroup.back,
    'quads' ||
    'hamstrings' ||
    'glutes' ||
    'adductors' ||
    'hipAbductors' ||
    'calves' => ExerciseGroup.legs,
    'biceps' => ExerciseGroup.biceps,
    'triceps' => ExerciseGroup.triceps,
    'shoulders' => ExerciseGroup.shoulders,
    'forearms' || 'abs' || 'neck' || 'other' => ExerciseGroup.other,

    final value => throw FormatException(
      'Unknown primary muscle for $exerciseId: $value',
    ),
  };
}

@JsonSerializable(createToJson: false)
class AssetExerciseAliasesDto {
  const AssetExerciseAliasesDto({required this.ar, required this.en});

  factory AssetExerciseAliasesDto.fromJson(Map<String, dynamic> json) =>
      _$AssetExerciseAliasesDtoFromJson(json);

  final List<String> ar;
  final List<String> en;
}

@JsonSerializable(createToJson: false)
class AssetExerciseFrameDto {
  const AssetExerciseFrameDto({this.path});

  factory AssetExerciseFrameDto.fromJson(Map<String, dynamic> json) =>
      _$AssetExerciseFrameDtoFromJson(json);

  final String? path;
}

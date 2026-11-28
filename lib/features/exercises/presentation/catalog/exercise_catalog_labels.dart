import '../../../../l10n/app_localizations.dart';
import '../../domain/exercise_definition.dart';

String groupLabel(AppLocalizations l, ExerciseGroup group) => switch (group) {
  ExerciseGroup.chest => l.muscleChest,
  ExerciseGroup.back => l.muscleBack,
  ExerciseGroup.legs => l.exerciseLegs,
  ExerciseGroup.biceps => l.muscleBiceps,
  ExerciseGroup.triceps => l.muscleTriceps,
  ExerciseGroup.shoulders => l.muscleShoulders,
  ExerciseGroup.other => l.muscleOther,
  ExerciseGroup.cardio => l.muscleCardio,
};

String equipmentLabel(AppLocalizations l, Equipment equipment) =>
    switch (equipment) {
      Equipment.machines => l.equipmentMachines,
      Equipment.noEquipment => l.equipmentNoEquipment,
      Equipment.dumbbell => l.equipmentDumbbell,
      Equipment.barbell => l.equipmentBarbell,
      Equipment.resistanceBand => l.equipmentBands,
      Equipment.kettlebell => l.equipmentKettlebell,
      Equipment.other => l.equipmentOther,
    };

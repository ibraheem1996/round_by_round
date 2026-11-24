import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_profile.freezed.dart';

@freezed
abstract class AccountProfile with _$AccountProfile {
  const factory AccountProfile({required double bodyWeightKg}) =
      _AccountProfile;

  static const minWeight = 40.0;
  static const maxWeight = 150.0;
  static const initialWeight = 80.0;
  static const weightStep = 0.5;

  static bool acceptsWeight(num value) =>
      value >= minWeight && value <= maxWeight && value % weightStep == 0;
}

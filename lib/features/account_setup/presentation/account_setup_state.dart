import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_setup_state.freezed.dart';

enum WeightSaveStatus { idle, saving, failed }

@freezed
abstract class AccountSetupState with _$AccountSetupState {
  const factory AccountSetupState.editing({
    required double weight,
    required WeightSaveStatus saveStatus,
  }) = AccountSetupEditing;
  const factory AccountSetupState.saved(double weight) = AccountSetupSaved;
}

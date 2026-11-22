import 'package:freezed_annotation/freezed_annotation.dart';

import '../account_profile.dart';

part 'account_setup_state.freezed.dart';

enum WeightSaveStatus { idle, saving, failed }

@freezed
abstract class AccountSetupState with _$AccountSetupState {
  const factory AccountSetupState.checking() = AccountSetupChecking;
  const factory AccountSetupState.unavailable() = AccountSetupUnavailable;
  const factory AccountSetupState.editing({
    required double weight,
    required WeightSaveStatus saveStatus,
  }) = AccountSetupEditing;
  const factory AccountSetupState.ready(AccountProfile profile) =
      AccountSetupReady;
}

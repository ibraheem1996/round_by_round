import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/services/logger_service.dart';
import '../account_profile.dart';
import '../account_repository.dart';
import 'account_setup_state.dart';

@injectable
final class AccountSetupCubit extends Cubit<AccountSetupState> {
  AccountSetupCubit(this._repository, @factoryParam String uid)
    : _uid = uid,
      super(
        const AccountSetupState.editing(
          weight: AccountProfile.initialWeight,
          saveStatus: WeightSaveStatus.idle,
        ),
      );

  final AccountRepository _repository;
  final String _uid;

  void selectWeight(double weight) {
    final current = state;
    if (current is AccountSetupEditing &&
        current.saveStatus != WeightSaveStatus.saving &&
        AccountProfile.acceptsWeight(weight)) {
      emit(current.copyWith(weight: weight, saveStatus: WeightSaveStatus.idle));
    }
  }

  Future<void> save() async {
    final current = state;
    if (current is! AccountSetupEditing ||
        current.saveStatus == WeightSaveStatus.saving) {
      return;
    }
    final profile = AccountProfile(bodyWeightKg: current.weight);
    emit(current.copyWith(saveStatus: WeightSaveStatus.saving));
    try {
      await _repository.save(_uid, profile);
      if (!isClosed) emit(AccountSetupState.saved(current.weight));
    } catch (error) {
      LoggerService.warning(
        'Local account save failed (${error.runtimeType}).',
      );
      if (!isClosed) {
        emit(current.copyWith(saveStatus: WeightSaveStatus.failed));
      }
    }
  }
}

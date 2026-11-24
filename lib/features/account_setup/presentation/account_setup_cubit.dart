import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/services/logger_service.dart';
import '../account_profile.dart';
import '../account_repository.dart';

part 'account_setup_cubit.freezed.dart';

enum WeightSaveStatus {
  idle,
  saving,
  failed,
  saved;

  bool get canEdit => this == idle || this == failed;
}

@freezed
abstract class AccountSetupState with _$AccountSetupState {
  const factory AccountSetupState({
    required double weight,
    @Default(WeightSaveStatus.idle) WeightSaveStatus saveStatus,
  }) = _AccountSetupState;
}

@injectable
final class AccountSetupCubit extends Cubit<AccountSetupState> {
  AccountSetupCubit(this._repository, @factoryParam String uid)
    : _uid = uid,
      super(const AccountSetupState(weight: AccountProfile.initialWeight));

  final AccountRepository _repository;
  final String _uid;

  void selectWeight(double weight) {
    final current = state;
    if (current.saveStatus.canEdit && AccountProfile.acceptsWeight(weight)) {
      emit(current.copyWith(weight: weight, saveStatus: WeightSaveStatus.idle));
    }
  }

  Future<void> save() async {
    final current = state;
    if (!current.saveStatus.canEdit) return;
    emit(current.copyWith(saveStatus: WeightSaveStatus.saving));
    try {
      await _repository.createIfMissing(
        _uid,
        AccountProfile(bodyWeightKg: current.weight),
      );
      if (!isClosed) emit(current.copyWith(saveStatus: WeightSaveStatus.saved));
    } catch (error) {
      LoggerService.warning(
        'Account setup save failed (${error.runtimeType}).',
      );
      if (!isClosed) {
        emit(current.copyWith(saveStatus: WeightSaveStatus.failed));
      }
    }
  }
}

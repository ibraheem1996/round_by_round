import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/services/logger_service.dart';
import '../account_profile.dart';
import '../account_repository.dart';
import 'account_setup_state.dart';

@injectable
final class AccountSetupCubit extends Cubit<AccountSetupState> {
  AccountSetupCubit(this._repository)
    : super(const AccountSetupState.checking());

  final AccountRepository _repository;
  StreamSubscription<AccountProfile?>? _observation;
  Timer? _deadline;
  String? _uid;
  Object? _observationId;

  String? get uid => _uid;

  void followSession(String? uid) {
    if (_uid == uid) return;
    _uid = uid;
    _observe();
  }

  void retry() {
    if (state is AccountSetupUnavailable) _observe();
  }

  void _observe() {
    _deadline?.cancel();
    unawaited(_observation?.cancel());
    final observationId = _observationId = Object();
    emit(const AccountSetupState.checking());
    final uid = _uid;
    if (uid == null) return;

    void unavailable() {
      if (_observationId != observationId) return;
      _deadline?.cancel();
      if (state is AccountSetupChecking) {
        emit(const AccountSetupState.unavailable());
      }
    }

    _deadline = Timer(const Duration(seconds: 10), unavailable);
    _observation = _repository
        .watch(uid)
        .listen(
          (profile) {
            if (_observationId != observationId ||
                state is AccountSetupEditing ||
                state is AccountSetupReady) {
              return;
            }
            _deadline?.cancel();
            emit(
              profile == null
                  ? const AccountSetupState.editing(
                      weight: AccountProfile.initialWeight,
                      saveStatus: WeightSaveStatus.idle,
                    )
                  : AccountSetupState.ready(profile),
            );
          },
          onError: (Object error) {
            LoggerService.warning(
              'Account read failed (${error.runtimeType}).',
            );
            unavailable();
          },
          onDone: unavailable,
        );
  }

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
    final uid = _uid;
    final observationId = _observationId;
    if (uid == null ||
        current is! AccountSetupEditing ||
        current.saveStatus == WeightSaveStatus.saving) {
      return;
    }
    final profile = AccountProfile(bodyWeightKg: current.weight);
    emit(current.copyWith(saveStatus: WeightSaveStatus.saving));
    try {
      await _repository.save(uid, profile);
      if (_observationId == observationId) {
        emit(AccountSetupState.ready(profile));
      }
    } catch (error) {
      LoggerService.warning(
        'Local account save failed (${error.runtimeType}).',
      );
      if (_observationId == observationId) {
        emit(current.copyWith(saveStatus: WeightSaveStatus.failed));
      }
    }
  }

  @override
  Future<void> close() async {
    _observationId = null;
    _deadline?.cancel();
    await _observation?.cancel();
    await super.close();
  }
}

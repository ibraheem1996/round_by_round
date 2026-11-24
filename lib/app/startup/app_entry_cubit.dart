import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/logger_service.dart';
import '../../features/account_setup/account_profile.dart';
import '../../features/account_setup/account_repository.dart';
import '../../features/authentication/auth_gateway.dart';
import 'app_entry_state.dart';

final class AppEntryCubit extends Cubit<AppEntryState> {
  AppEntryCubit(
    this._auth,
    this._accounts,
    bool introCompleted,
    Future<void> Function() saveOnboardingCompletion,
  ) : _introCompleted = introCompleted,
      _saveOnboardingCompletion = saveOnboardingCompletion,
      super(const AppEntryState.restoringSession());

  static const _lookupTimeout = Duration(seconds: 10);

  final AuthGateway _auth;
  final AccountRepository _accounts;
  final Future<void> Function() _saveOnboardingCompletion;

  bool _introCompleted;
  Timer? _deadline;
  StreamSubscription<String?>? _session;
  StreamSubscription<AccountProfile?>? _account;

  void start() {
    if (!isClosed && _session == null && state is EntryRestoringSession) {
      unawaited(_restoreSession());
    }
  }

  void retry() {
    if (isClosed) return;
    switch (state) {
      case EntrySessionUnavailable():
        unawaited(_restoreSession());
      case EntryAccountUnavailable(:final uid):
        _checkAccount(uid);
      default:
        break;
    }
  }

  Future<void> completeIntro() async {
    await _saveOnboardingCompletion();
    if (isClosed) return;
    _introCompleted = true;
    if (state is EntryOnboarding) emit(const AppEntryState.login());
  }

  void completeAccountSetup(String uid) {
    if (!isClosed && state == AppEntryState.setupRequired(uid)) {
      emit(AppEntryState.ready(uid));
    }
  }

  Future<void> _restoreSession() async {
    _deadline?.cancel();
    emit(const AppEntryState.restoringSession());

    try {
      if (_session case final previous?) await previous.cancel();
      if (isClosed) return;
      _deadline = Timer(_lookupTimeout, _sessionUnavailable);
      _session = _auth.watchUserId().listen(
        _sessionChanged,
        onError: _sessionFailed,
        onDone: _sessionUnavailable,
      );
    } catch (error) {
      _sessionFailed(error);
    }
  }

  void _sessionChanged(String? uid) {
    if (uid == null) {
      _deadline?.cancel();
      unawaited(_stopAccount());
      emit(
        _introCompleted
            ? const AppEntryState.login()
            : const AppEntryState.onboarding(),
      );
    } else if (state.activeUid != uid) {
      _checkAccount(uid);
    }
  }

  void _sessionFailed(Object error) {
    LoggerService.warning('Auth session failed (${error.runtimeType}).');
    _sessionUnavailable();
  }

  void _sessionUnavailable() {
    if (isClosed) return;
    _deadline?.cancel();
    unawaited(_stopAccount());
    emit(const AppEntryState.sessionUnavailable());
  }

  void _checkAccount(String uid) {
    _deadline?.cancel();
    unawaited(_stopAccount());
    emit(AppEntryState.checkingAccount(uid));

    void finish(AppEntryState next) {
      _deadline?.cancel();
      unawaited(_stopAccount());
      emit(next);
    }

    void unavailable() => finish(AppEntryState.accountUnavailable(uid));

    void reportError(Object error) {
      LoggerService.warning('Account read failed (${error.runtimeType}).');
      unavailable();
    }

    _deadline = Timer(_lookupTimeout, unavailable);
    try {
      _account = _accounts
          .check(uid)
          .listen(
            (profile) => finish(
              profile == null
                  ? AppEntryState.setupRequired(uid)
                  : AppEntryState.ready(uid),
            ),
            onError: reportError,
            onDone: unavailable,
          );
    } catch (error) {
      reportError(error);
    }
  }

  Future<void> _stopAccount() async {
    final previous = _account;
    _account = null;
    try {
      await previous?.cancel();
    } catch (error) {
      LoggerService.warning(
        'Account check could not close (${error.runtimeType}).',
      );
    }
  }

  @override
  Future<void> close() async {
    _deadline?.cancel();
    await Future.wait([
      super.close(),
      if (_session case final session?) session.cancel(),
      _stopAccount(),
    ]);
  }
}

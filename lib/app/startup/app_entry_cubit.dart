import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/services/logger_service.dart';
import '../../features/account_setup/account_profile.dart';
import '../../features/account_setup/account_repository.dart';
import '../../features/authentication/auth_gateway.dart';
import 'app_entry_state.dart';

typedef SaveIntro = Future<void> Function();

@injectable
final class AppEntryCubit extends Cubit<AppEntryState> {
  AppEntryCubit(
    this._auth,
    this._accounts,
    @factoryParam bool introCompleted,
    @factoryParam SaveIntro persistIntro,
  ) : _introCompleted = introCompleted,
      _persistIntro = persistIntro,
      super(const AppEntryState.restoringSession());

  static const _lookupTimeout = Duration(seconds: 10);

  final AuthGateway _auth;
  final AccountRepository _accounts;
  final SaveIntro _persistIntro;

  bool _introCompleted;
  Object? _authAttempt;
  Timer? _deadline;
  StreamSubscription<String?>? _session;
  StreamSubscription<AccountProfile?>? _account;

  void start() {
    if (_authAttempt == null && !isClosed) unawaited(_restoreSession());
  }

  void retry() {
    if (_authAttempt == null) return;
    switch (state) {
      case EntrySessionUnavailable():
        unawaited(_restoreSession());
      case EntryAccountUnavailable(:final account):
        _checkAccount(account.uid);
      default:
        break;
    }
  }

  Future<void> completeIntro() async {
    await _persistIntro();
    if (_authAttempt == null) return;
    _introCompleted = true;
    if (state is EntryOnboarding) emit(const AppEntryState.login());
  }

  void completeAccountSetup(EntryAccount account) {
    final current = state;
    if (_authAttempt != null &&
        current is EntrySetupRequired &&
        current.account == account) {
      emit(AppEntryState.ready(account));
    }
  }

  Future<void> _restoreSession() async {
    final attempt = _authAttempt = Object();
    _deadline?.cancel();
    emit(const AppEntryState.restoringSession());

    void unavailable() {
      if (_authAttempt != attempt) return;
      _deadline?.cancel();
      emit(const AppEntryState.sessionUnavailable());
      unawaited(_stopAccount());
    }

    try {
      await _session?.cancel();
      if (_authAttempt != attempt) return;
      _deadline = Timer(_lookupTimeout, unavailable);
      _session = _auth.watchUserId().listen(
        (uid) {
          if (_authAttempt != attempt) return;
          if (uid == null) {
            _deadline?.cancel();
            emit(
              _introCompleted
                  ? const AppEntryState.login()
                  : const AppEntryState.onboarding(),
            );
            unawaited(_stopAccount());
          } else if (state.activeAccount?.uid != uid) {
            _checkAccount(uid);
          }
        },
        onError: (Object error) {
          LoggerService.warning(
            'Auth session stream failed (${error.runtimeType}).',
          );
          unavailable();
        },
        onDone: unavailable,
      );
    } catch (error) {
      LoggerService.warning(
        'Auth session could not start (${error.runtimeType}).',
      );
      unavailable();
    }
  }

  void _checkAccount(String uid) {
    _deadline?.cancel();
    final account = (uid: uid, lifetime: Object());
    emit(AppEntryState.checkingAccount(account));
    unawaited(_stopAccount());

    void unavailable() {
      if (_authAttempt == null ||
          state.activeAccount != account ||
          state is! EntryCheckingAccount) {
        return;
      }
      _deadline?.cancel();
      emit(AppEntryState.accountUnavailable(account));
    }

    void reportError(Object error) {
      LoggerService.warning('Account read failed (${error.runtimeType}).');
      unavailable();
    }

    _deadline = Timer(_lookupTimeout, unavailable);
    try {
      // Keep observing after the gate resolves so the repository can reconcile
      // the recovery file when the device reconnects.
      _account = _accounts
          .watch(uid)
          .listen(
            (profile) {
              if (_authAttempt == null ||
                  state.activeAccount != account ||
                  (state is! EntryCheckingAccount &&
                      state is! EntryAccountUnavailable)) {
                return;
              }
              _deadline?.cancel();
              emit(
                profile == null
                    ? AppEntryState.setupRequired(account)
                    : AppEntryState.ready(account),
              );
            },
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
        'Account observation could not close (${error.runtimeType}).',
      );
    }
  }

  @override
  Future<void> close() async {
    _authAttempt = null;
    _deadline?.cancel();
    await Future.wait([
      super.close(),
      if (_session case final session?) session.cancel(),
      _stopAccount(),
    ]);
  }
}

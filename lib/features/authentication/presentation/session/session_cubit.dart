import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/services/logger_service.dart';
import '../../auth_gateway.dart';
import 'session_state.dart';

@injectable
final class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._gateway) : super(const SessionState.restoring());

  static const _restoreTimeout = Duration(seconds: 10);

  final AuthGateway _gateway;
  StreamSubscription<String?>? _session;
  Timer? _restoreTimer;
  bool _connecting = false;
  bool _closing = false;

  /// Starts observing the local auth stream through sign-in and sign-out.
  /// Retry replaces the previous subscription.
  Future<void> restoreSession() async {
    if (_closing || _connecting) return;
    _connecting = true;
    emit(const SessionState.restoring());
    try {
      _restoreTimer?.cancel();
      await _session?.cancel();
      if (_closing) return;
      _restoreTimer = Timer(_restoreTimeout, _sessionUnavailable);
      _session = _gateway.watchUserId().listen(
        (event) => _sessionChanged(event),
        onError: (Object error) {
          LoggerService.warning(
            'Auth session stream failed (${error.runtimeType}).',
          );
          _sessionUnavailable();
        },
        onDone: _sessionUnavailable,
      );
    } catch (error) {
      LoggerService.warning(
        'Auth session could not start (${error.runtimeType}).',
      );
      _sessionUnavailable();
    } finally {
      _connecting = false;
    }
  }

  void _sessionChanged(String? uid) {
    if (_closing) return;
    _restoreTimer?.cancel();
    emit(
      uid == null ? const SessionState.signedOut() : SessionState.signedIn(uid),
    );
  }

  void _sessionUnavailable() {
    _restoreTimer?.cancel();
    if (!_closing) emit(const SessionState.unavailable());
  }

  @override
  Future<void> close() async {
    _closing = true;
    _restoreTimer?.cancel();
    await _session?.cancel();
    await super.close();
  }
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/services/logger_service.dart';
import '../auth_gateway.dart';
import 'auth_state.dart';

@injectable
final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._gateway) : super(const AuthRestoring());

  static const _sessionWait = Duration(seconds: 10);

  final AuthGateway _gateway;
  StreamSubscription<String?>? _session;
  Timer? _sessionTimeout;
  bool _connecting = false;
  bool _providerRequestActive = false;
  bool _closing = false;

  Future<void> restoreSession() async {
    if (_closing || _connecting) return;
    _connecting = true;
    emit(const AuthRestoring());
    try {
      _sessionTimeout?.cancel();
      await _session?.cancel();
      if (_closing) return;
      _sessionTimeout = Timer(_sessionWait, _sessionUnavailable);
      _session = _gateway.watchUserId().listen(
        _sessionChanged,
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

  Future<void> signIn(SignInProvider provider) async {
    if (_closing || _providerRequestActive || state is! AuthSignedOut) return;
    _providerRequestActive = true;
    emit(const AuthSigningIn());

    final SignInResult result;
    try {
      result = await _gateway.signIn(provider);
    } catch (error) {
      LoggerService.warning('Sign-in failed (${error.runtimeType}).');
      _finishSignIn(SignInResult.failed);
      return;
    } finally {
      _providerRequestActive = false;
    }
    _finishSignIn(result);
  }

  void _finishSignIn(SignInResult result) {
    if (_closing || state is! AuthSigningIn) return;
    switch (result) {
      case SignInResult.success:
        // Only the session stream can confirm sign-in and unlock the app.
        _sessionTimeout = Timer(_sessionWait, () {
          if (state is AuthSigningIn) {
            emit(const AuthSignedOut(error: SignInResult.failed));
          }
        });
      case SignInResult.canceled:
        emit(const AuthSignedOut());
      default:
        emit(AuthSignedOut(error: result));
    }
  }

  void _sessionChanged(String? uid) {
    if (_closing) return;
    _sessionTimeout?.cancel();
    emit(uid == null ? const AuthSignedOut() : AuthSignedIn(uid));
  }

  void _sessionUnavailable() {
    _sessionTimeout?.cancel();
    if (!_closing) emit(const AuthUnavailable());
  }

  @override
  Future<void> close() async {
    _closing = true;
    _sessionTimeout?.cancel();
    await _session?.cancel();
    await super.close();
  }
}

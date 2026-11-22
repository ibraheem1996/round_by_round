import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/services/logger_service.dart';
import '../../auth_gateway.dart';
import 'login_state.dart';

@injectable
final class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._gateway) : super(const LoginState.idle());

  static const _confirmationTimeout = Duration(seconds: 10);

  final AuthGateway _gateway;
  Timer? _confirmationTimer;

  Future<void> signIn(SignInProvider provider) async {
    if (isClosed || state is LoginSubmitting) return;
    emit(const LoginState.submitting());

    final SignInResult result;
    try {
      result = await _gateway.signIn(provider);
    } catch (error) {
      LoggerService.warning('Sign-in failed (${error.runtimeType}).');
      if (!isClosed) emit(const LoginState.failure(SignInResult.failed));
      return;
    }
    if (isClosed) return;

    switch (result) {
      case SignInResult.success:

        // Session confirmation navigates away and disposes this attempt.
        _confirmationTimer = Timer(_confirmationTimeout, () {
          emit(const LoginState.failure(SignInResult.failed));
        });
      case SignInResult.canceled:
        emit(const LoginState.idle());
      default:
        emit(LoginState.failure(result));
    }
  }

  @override
  Future<void> close() {
    _confirmationTimer?.cancel();
    return super.close();
  }
}

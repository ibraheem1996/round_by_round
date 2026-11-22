import 'package:freezed_annotation/freezed_annotation.dart';

import '../../auth_gateway.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState.idle() = LoginIdle;
  const factory LoginState.submitting() = LoginSubmitting;
  const factory LoginState.failure(SignInResult error) = LoginFailure;
}

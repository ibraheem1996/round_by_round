import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:round_by_round/features/authentication/auth_gateway.dart';
import 'package:round_by_round/features/authentication/presentation/login/login_cubit.dart';
import 'package:round_by_round/features/authentication/presentation/login/login_state.dart';

import '../../support/test_auth_gateway.dart';

void main() {
  test(
    'blocks duplicate submissions and lets a canceled or failed attempt retry',
    () async {
      final response = Completer<SignInResult>();
      final gateway = TestAuthGateway()..onSignIn = () => response.future;
      addTearDown(gateway.close);
      final cubit = LoginCubit(gateway);
      addTearDown(cubit.close);

      final pending = cubit.signIn(SignInProvider.google);
      expect(cubit.state, const LoginState.submitting());
      await cubit.signIn(SignInProvider.google);
      await cubit.signIn(SignInProvider.apple);
      expect(gateway.calls, [SignInProvider.google]);

      response.complete(SignInResult.canceled);
      await pending;
      expect(cubit.state, const LoginState.idle());

      gateway.onSignIn = () async => SignInResult.networkError;
      await cubit.signIn(SignInProvider.apple);
      expect(cubit.state, const LoginState.failure(SignInResult.networkError));

      gateway.onSignIn = () async => throw StateError('Provider unavailable');
      await cubit.signIn(SignInProvider.google);
      expect(cubit.state, const LoginState.failure(SignInResult.failed));
    },
  );

  test('ignores a provider response that arrives after closing', () async {
    final response = Completer<SignInResult>();
    final gateway = TestAuthGateway()..onSignIn = () => response.future;
    addTearDown(gateway.close);
    final cubit = LoginCubit(gateway);

    final pending = cubit.signIn(SignInProvider.google);
    await cubit.close();
    response.complete(SignInResult.success);
    await pending;
    expect(cubit.state, const LoginState.submitting());
  });
}

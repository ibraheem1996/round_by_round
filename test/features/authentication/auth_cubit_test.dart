import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:round_by_round/features/authentication/auth_gateway.dart';
import 'package:round_by_round/features/authentication/presentation/auth_cubit.dart';
import 'package:round_by_round/features/authentication/presentation/auth_state.dart';

import '../../support/test_auth_gateway.dart';

void main() {
  test(
    'waits for the session and lets Firebase confirm Google success',
    () async {
      final gateway = TestAuthGateway(delayInitialEvent: true);
      final cubit = AuthCubit(gateway);
      addTearDown(gateway.close);
      addTearDown(cubit.close);

      await cubit.restoreSession();
      expect(cubit.state, isA<AuthRestoring>());
      await cubit.signIn(SignInProvider.google);
      expect(gateway.calls, isEmpty);

      final signedOut = cubit.stream.firstWhere(
        (state) => state is AuthSignedOut,
      );
      gateway.emitSession(null);
      await signedOut;

      final response = Completer<SignInResult>();
      gateway.onSignIn = () => response.future;
      final signingIn = cubit.signIn(SignInProvider.google);
      expect(cubit.state, isA<AuthSigningIn>());
      await cubit.signIn(SignInProvider.google);
      await cubit.signIn(SignInProvider.apple);
      expect(gateway.calls, [SignInProvider.google]);

      response.complete(SignInResult.success);
      await signingIn;
      expect(cubit.state, isA<AuthSigningIn>());

      final session = cubit.stream.firstWhere((state) => state is AuthSignedIn);
      gateway.emitSession('test-uid');
      expect((await session as AuthSignedIn).uid, 'test-uid');
    },
  );

  test(
    'handles Apple cancellation, failure, and success through the fake',
    () async {
      final gateway = TestAuthGateway();
      final cubit = AuthCubit(gateway);
      addTearDown(gateway.close);
      addTearDown(cubit.close);

      final ready = cubit.stream.firstWhere((state) => state is AuthSignedOut);
      await cubit.restoreSession();
      await ready;

      await cubit.signIn(SignInProvider.apple);
      expect((cubit.state as AuthSignedOut).error, isNull);

      gateway.onSignIn = () async => SignInResult.networkError;
      await cubit.signIn(SignInProvider.apple);
      expect((cubit.state as AuthSignedOut).error, SignInResult.networkError);

      gateway.onSignIn = () async => SignInResult.success;
      await cubit.signIn(SignInProvider.apple);
      final session = cubit.stream.firstWhere((state) => state is AuthSignedIn);
      gateway.emitSession('apple-test-uid');
      expect((await session as AuthSignedIn).uid, 'apple-test-uid');
      expect(gateway.calls, List.filled(3, SignInProvider.apple));
    },
  );

  test('ignores a provider response that arrives after closing', () async {
    final gateway = TestAuthGateway();
    addTearDown(gateway.close);
    final cubit = AuthCubit(gateway);
    final ready = cubit.stream.firstWhere((state) => state is AuthSignedOut);
    await cubit.restoreSession();
    await ready;
    final response = Completer<SignInResult>();
    gateway.onSignIn = () => response.future;

    final pending = cubit.signIn(SignInProvider.google);
    await cubit.close();
    response.complete(SignInResult.failed);
    await pending;
    expect(cubit.state, isA<AuthSigningIn>());
  });
}

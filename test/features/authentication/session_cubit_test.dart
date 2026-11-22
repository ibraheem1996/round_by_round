import 'package:flutter_test/flutter_test.dart';
import 'package:round_by_round/features/authentication/presentation/session/session_cubit.dart';
import 'package:round_by_round/features/authentication/presentation/session/session_state.dart';

import '../../support/test_auth_gateway.dart';

void main() {
  test('restores the cached UID and observes sign-out and sign-in', () async {
    final gateway = TestAuthGateway(userId: 'cached-user');
    addTearDown(gateway.close);
    final cubit = SessionCubit(gateway);
    addTearDown(cubit.close);

    final states = expectLater(
      cubit.stream,
      emitsInOrder([
        const SessionState.restoring(),
        const SessionState.signedIn('cached-user'),
        const SessionState.signedOut(),
        const SessionState.signedIn('other-user'),
      ]),
    );
    await cubit.restoreSession();
    gateway.emitSession(null);
    gateway.emitSession('other-user');

    await states;
    expect(gateway.calls, isEmpty);
  });

  test('retry replaces the failed session subscription', () async {
    final gateway = TestAuthGateway();
    addTearDown(gateway.close);
    final cubit = SessionCubit(gateway);
    final states = expectLater(
      cubit.stream,
      emitsInOrder([
        const SessionState.restoring(),
        const SessionState.signedOut(),
        const SessionState.unavailable(),
        const SessionState.restoring(),
        const SessionState.signedIn('returning-user'),
      ]),
    );

    await cubit.restoreSession();
    gateway.failSession();
    await cubit.stream.firstWhere((state) => state is SessionUnavailable);
    gateway.userId = 'returning-user';
    await cubit.restoreSession();
    await states;
    expect(gateway.sessionListeners, 1);
    await cubit.close();
    expect(gateway.sessionListeners, 0);
  });
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:round_by_round/app/startup/app_entry_cubit.dart';
import 'package:round_by_round/app/startup/app_entry_state.dart';
import 'package:round_by_round/features/account_setup/account_profile.dart';

import '../support/test_auth_gateway.dart';

void main() {
  test('restores a cached UID then changes the active account on sign-out and sign-in', () async {
    final gateway = TestAuthGateway(userId: 'cached-user');
    final accounts = TestAccountRepository();
    final cubit = AppEntryCubit(gateway, accounts, true, () async {});
    addTearDown(gateway.close);
    addTearDown(cubit.close);
    final firstReady = cubit.stream.firstWhere((state) => state is EntryReady);
    cubit.start();
    expect((await firstReady).activeAccount?.uid, 'cached-user');
    final signedOut = cubit.stream.firstWhere((state) => state is EntryLogin);
    gateway.emitSession(null);
    await signedOut;
    final nextReady = cubit.stream.firstWhere((state) => state is EntryReady);
    gateway.emitSession('other-user');
    expect((await nextReady).activeAccount?.uid, 'other-user');
    expect(accounts.observations, ['cached-user', 'other-user']);
    expect(gateway.calls, isEmpty);
  });

  test(
    'auth retry replaces the failed observer and does not duplicate it',
    () async {
      final gateway = TestAuthGateway();
      final cubit = AppEntryCubit(
        gateway,
        TestAccountRepository(),
        false,
        () async {},
      );
      addTearDown(gateway.close);
      addTearDown(cubit.close);
      final intro = cubit.stream.firstWhere(
        (state) => state is EntryOnboarding,
      );
      cubit.start();
      cubit.start();
      await intro;
      final unavailable = cubit.stream.firstWhere(
        (state) => state is EntrySessionUnavailable,
      );
      gateway.failSession();
      await unavailable;
      gateway.userId = 'returning-user';
      final ready = cubit.stream.firstWhere((state) => state is EntryReady);
      cubit.retry();
      cubit.retry();
      expect((await ready).activeAccount?.uid, 'returning-user');
      expect(gateway.sessionListeners, 1);
      await cubit.close();
      expect(gateway.sessionListeners, 0);
    },
  );

  test(
    'a completion from an earlier visit to the same UID cannot unlock setup',
    () async {
      final gateway = TestAuthGateway(userId: 'A');
      final cubit = AppEntryCubit(
        gateway,
        TestAccountRepository(profile: null),
        true,
        () async {},
      );
      addTearDown(gateway.close);
      addTearDown(cubit.close);

      Future<EntryAccount> setupFor(String uid) async {
        final setup = await cubit.stream.firstWhere(
          (state) => state is EntrySetupRequired && state.account.uid == uid,
        );
        return (setup as EntrySetupRequired).account;
      }

      final firstSetup = setupFor('A');
      cubit.start();
      final original = await firstSetup;
      final secondSetup = setupFor('B');
      gateway.emitSession('B');
      await secondSetup;
      final reenteredSetup = setupFor('A');
      gateway.emitSession('A');
      final current = await reenteredSetup;

      cubit.completeAccountSetup(original);
      expect(cubit.state, AppEntryState.setupRequired(current));
      cubit.completeAccountSetup(current);
      expect(cubit.state, AppEntryState.ready(current));
    },
  );

  test(
    'account retry keeps the auth observer and replaces the read that failed',
    () async {
      final gateway = TestAuthGateway(userId: 'owner');
      final failed = StreamController<AccountProfile?>();
      final accounts = TestAccountRepository()..onWatch = (_) => failed.stream;
      final cubit = AppEntryCubit(gateway, accounts, true, () async {});
      addTearDown(gateway.close);
      addTearDown(failed.close);
      addTearDown(cubit.close);
      final checking = cubit.stream.firstWhere(
        (state) => state is EntryCheckingAccount,
      );
      cubit.start();
      await checking;
      final unavailable = cubit.stream.firstWhere(
        (state) => state is EntryAccountUnavailable,
      );
      failed.addError(StateError('read unavailable'));
      await unavailable;
      accounts.onWatch = (_) =>
          Stream.value(const AccountProfile(bodyWeightKg: 85));
      final restored = cubit.stream.firstWhere((state) => state is EntryReady);
      cubit.retry();
      expect((await restored).activeAccount?.uid, 'owner');
      expect(accounts.observations, ['owner', 'owner']);
      expect(gateway.sessionListeners, 1);
    },
  );
}

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
    expect((await firstReady).activeUid, 'cached-user');
    final signedOut = cubit.stream.firstWhere((state) => state is EntryLogin);
    gateway.emitSession(null);
    await signedOut;
    final nextReady = cubit.stream.firstWhere((state) => state is EntryReady);
    gateway.emitSession('other-user');
    expect((await nextReady).activeUid, 'other-user');
    expect(accounts.checks, ['cached-user', 'other-user']);
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
      expect((await ready).activeUid, 'returning-user');
      expect(gateway.sessionListeners, 1);
      await cubit.close();
      expect(gateway.sessionListeners, 0);
    },
  );

  test('a save for a different UID cannot unlock setup', () async {
    final gateway = TestAuthGateway(userId: 'A');
    final cubit = AppEntryCubit(
      gateway,
      TestAccountRepository(profile: null),
      true,
      () async {},
    );
    addTearDown(gateway.close);
    addTearDown(cubit.close);

    Future<AppEntryState> setupFor(String uid) => cubit.stream.firstWhere(
      (state) => state == AppEntryState.setupRequired(uid),
    );

    final firstSetup = setupFor('A');
    cubit.start();
    await firstSetup;
    final secondSetup = setupFor('B');
    gateway.emitSession('B');
    final current = await secondSetup;

    cubit.completeAccountSetup('A');
    expect(cubit.state, current);
    cubit.completeAccountSetup('B');
    expect(cubit.state, const AppEntryState.ready('B'));
  });

  test(
    'account retry keeps the auth observer and replaces the read that failed',
    () async {
      final gateway = TestAuthGateway(userId: 'owner');
      final failed = StreamController<AccountProfile?>();
      final accounts = TestAccountRepository()..onCheck = (_) => failed.stream;
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
      expect(failed.hasListener, isFalse);
      accounts.onCheck = (_) =>
          Stream.value(const AccountProfile(bodyWeightKg: 85));
      final restored = cubit.stream.firstWhere((state) => state is EntryReady);
      cubit.retry();
      expect((await restored).activeUid, 'owner');
      expect(accounts.checks, ['owner', 'owner']);
      expect(gateway.sessionListeners, 1);
    },
  );

  test('switching UID cancels the previous account check', () async {
    final gateway = TestAuthGateway(userId: 'first');
    final firstRead = StreamController<AccountProfile?>.broadcast();
    final secondRead = StreamController<AccountProfile?>.broadcast();
    final accounts = TestAccountRepository()
      ..onCheck = (uid) =>
          uid == 'first' ? firstRead.stream : secondRead.stream;
    final cubit = AppEntryCubit(gateway, accounts, true, () async {});
    addTearDown(gateway.close);
    addTearDown(firstRead.close);
    addTearDown(secondRead.close);
    addTearDown(cubit.close);

    final checkingFirst = cubit.stream.firstWhere(
      (state) => state == const AppEntryState.checkingAccount('first'),
    );
    cubit.start();
    await checkingFirst;
    expect(firstRead.hasListener, isTrue);

    final checkingSecond = cubit.stream.firstWhere(
      (state) => state == const AppEntryState.checkingAccount('second'),
    );
    gateway.emitSession('second');
    await checkingSecond;
    expect(firstRead.hasListener, isFalse);
    firstRead.add(const AccountProfile(bodyWeightKg: 85));

    final requiresSetup = cubit.stream.first;
    secondRead.add(null);
    expect(await requiresSetup, const AppEntryState.setupRequired('second'));
    expect(secondRead.hasListener, isFalse);
  });
}

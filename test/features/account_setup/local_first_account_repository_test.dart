import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:round_by_round/features/account_setup/account_profile.dart';
import 'package:round_by_round/features/account_setup/data/account_cloud_store.dart';
import 'package:round_by_round/features/account_setup/data/account_recovery_store.dart';
import 'package:round_by_round/features/account_setup/data/local_first_account_repository.dart';

const _weight = AccountProfile(bodyWeightKg: 81.5);
const _older = AccountProfile(bodyWeightKg: 80);
const _missing = (profile: null, exists: false, confirmed: true);

void main() {
  late Directory directory;
  late AccountRecoveryStore recovery;
  late _Cloud cloud;
  late LocalFirstAccountRepository repository;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('account_weight_test_');
    recovery = AccountRecoveryStore.inDirectory(() async => directory);
    cloud = _Cloud();
    repository = LocalFirstAccountRepository(recovery, cloud);
  });

  tearDown(() async {
    await cloud.events.close();
    await directory.delete(recursive: true);
  });

  test(
    'cache absence does not invite setup before server confirmation',
    () async {
      final ready = repository.watch('owner').first;
      await cloud.listening.future;
      cloud.events.add((profile: null, exists: false, confirmed: false));
      cloud.events.add((profile: _older, exists: true, confirmed: true));
      expect(await ready, _older);
    },
  );

  test('server-confirmed absence permits setup', () async {
    final ready = repository.watch('owner').first;
    await cloud.listening.future;
    cloud.events.add(_missing);
    expect(await ready, isNull);
  });

  test('save survives rejection, restart and a different account', () async {
    cloud.write = Future<void>.error(StateError('write rejected'));
    // Attach a handler while the local I/O is still in progress.
    unawaited(cloud.write!.catchError((Object _) {}));
    await repository.save('owner', _weight);
    expect(cloud.saves, [('owner', _weight)]);

    final restartedStore = AccountRecoveryStore.inDirectory(
      () async => directory,
    );
    final restarted = LocalFirstAccountRepository(restartedStore, cloud);
    expect(await restarted.watch('owner').first, _weight);
    expect(await restartedStore.read('another owner'), isNull);
  });

  test(
    'restores a saved weight and submits it when the account is absent',
    () async {
      await recovery.write('owner', _weight);
      final events = StreamIterator(repository.watch('owner'));
      addTearDown(events.cancel);
      expect(await events.moveNext(), isTrue);
      expect(events.current, _weight);

      final retry = events.moveNext();
      await cloud.listening.future;
      cloud.events.add(_missing);
      expect(await retry, isTrue);
      expect(cloud.saves, [('owner', _weight)]);
      await events.cancel();
    },
  );

  test(
    'keeps newer recoverable data until a matching server confirmation',
    () async {
      await recovery.write('owner', _weight);
      final events = StreamIterator(repository.watch('owner'));
      addTearDown(events.cancel);
      expect(await events.moveNext(), isTrue);

      final conflict = events.moveNext();
      await cloud.listening.future;
      cloud.events.add((profile: _older, exists: true, confirmed: true));
      expect(await conflict, isTrue);
      expect(events.current, _weight);
      expect(await recovery.read('owner'), _weight);
      expect(cloud.saves, isEmpty);

      final confirmation = events.moveNext();
      cloud.events.add((profile: _weight, exists: true, confirmed: true));
      expect(await confirmation, isTrue);
      expect(await recovery.read('owner'), isNull);
      await events.cancel();
    },
  );

  test('a reconnect retries after the earlier cloud attempt fails', () async {
    final failedAttempt = Completer<void>();
    cloud.write = failedAttempt.future;
    await repository.save('owner', _weight);

    final events = StreamIterator(repository.watch('owner'));
    addTearDown(events.cancel);
    expect(await events.moveNext(), isTrue);
    final confirmedAbsence = events.moveNext();
    await cloud.listening.future;
    cloud.events.add(_missing);
    expect(await confirmedAbsence, isTrue);
    expect(cloud.saves, hasLength(1));

    final retried = Completer<void>();
    cloud.write = null;
    cloud.onSave = retried.complete;
    failedAttempt.completeError(StateError('connection lost'));
    await retried.future;
    expect(cloud.saves, [('owner', _weight), ('owner', _weight)]);
    await events.cancel();
  });

  test('a failed local write never submits to the cloud', () async {
    final failure = LocalFirstAccountRepository(
      AccountRecoveryStore.inDirectory(
        () async => throw const FileSystemException('unavailable'),
      ),
      cloud,
    );
    await expectLater(
      failure.save('owner', _weight),
      throwsA(isA<FileSystemException>()),
    );
    expect(cloud.saves, isEmpty);
    await expectLater(
      repository.save('owner', const AccountProfile(bodyWeightKg: 40.25)),
      throwsArgumentError,
    );
  });
}

final class _Cloud implements AccountCloudStore {
  final listening = Completer<void>();
  late final events = StreamController<CloudAccount>.broadcast(
    onListen: listening.complete,
  );
  final saves = <(String, AccountProfile)>[];
  Future<void>? write;
  void Function()? onSave;

  @override
  Stream<CloudAccount> watch(String uid) => events.stream;

  @override
  Future<void> createIfMissing(String uid, AccountProfile profile) async {
    saves.add((uid, profile));
    onSave?.call();
    await write;
  }
}

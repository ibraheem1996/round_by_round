import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../core/services/logger_service.dart';
import '../account_profile.dart';
import '../account_repository.dart';
import 'account_cloud_store.dart';
import 'account_recovery_store.dart';

@LazySingleton(as: AccountRepository)
final class LocalFirstAccountRepository implements AccountRepository {
  LocalFirstAccountRepository(this._recovery, this._cloud);

  final AccountRecoveryStore _recovery;
  final AccountCloudStore _cloud;
  final _sending = <String, Future<bool>>{};

  @override
  Stream<AccountProfile?> watch(String uid) async* {
    final local = await _recovery.read(uid);
    if (local != null) yield local;

    AccountProfile? attempted;
    await for (final snapshot in _cloud.watch(uid)) {
      final pending = await _recovery.read(uid);
      if (pending != null) {
        if (!snapshot.confirmed) {
          attempted = null;
        } else if (snapshot.profile == pending) {
          try {
            await _recovery.clearIfMatches(uid, pending);
          } catch (error) {
            LoggerService.warning(
              'Account recovery cleanup failed (${error.runtimeType}).',
            );
          }
        } else if (snapshot.exists) {
          LoggerService.warning('Account weight differs from the server copy.');
        } else if (attempted != pending) {
          attempted = pending;
          unawaited(_send(uid, pending, afterReconnect: true));
        }
        yield pending;
      } else if (snapshot.profile case final profile?) {
        yield profile;
      } else if (snapshot.exists && snapshot.confirmed) {
        throw const FormatException('Invalid account weight');
      } else if (!snapshot.exists && snapshot.confirmed) {
        yield null;
      }
    }
  }

  @override
  Future<void> save(String uid, AccountProfile profile) async {
    if (!AccountProfile.acceptsWeight(profile.bodyWeightKg)) {
      throw ArgumentError('Invalid account weight');
    }
    await _recovery.write(uid, profile);
    unawaited(_send(uid, profile));
  }

  Future<void> _send(
    String uid,
    AccountProfile profile, {
    bool afterReconnect = false,
  }) async {
    final inFlight = _sending[uid];
    // A confirmed read after reconnect can arrive before the old request fails.
    if (inFlight != null) {
      if (!afterReconnect || await inFlight) return;
      try {
        if (await _recovery.read(uid) != profile) return;
      } catch (error) {
        LoggerService.warning(
          'Account recovery read failed (${error.runtimeType}).',
        );
        return;
      }
    }
    if (_sending.containsKey(uid)) return;
    final operation = _createIfMissing(uid, profile).whenComplete(() {
      _sending.remove(uid);
    });
    _sending[uid] = operation;
    await operation;
  }

  Future<bool> _createIfMissing(String uid, AccountProfile profile) async {
    try {
      await _cloud.createIfMissing(uid, profile);
      return true;
    } catch (error) {
      // The durable record remains available even if this cloud attempt fails.
      LoggerService.warning('Account sync failed (${error.runtimeType}).');
      return false;
    }
  }
}

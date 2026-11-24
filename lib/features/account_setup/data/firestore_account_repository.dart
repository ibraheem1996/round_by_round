import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../core/services/logger_service.dart';
import '../account_profile.dart';
import '../account_repository.dart';

@LazySingleton(as: AccountRepository)
final class FirestoreAccountRepository implements AccountRepository {
  FirestoreAccountRepository(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Stream<AccountProfile?> check(String uid) async* {
    _requireActiveUser(uid);
    final snapshots = _document(uid).snapshots(includeMetadataChanges: true);
    await for (final snapshot in snapshots) {
      if (snapshot.metadata.hasPendingWrites) continue;
      final profile = _readProfile(snapshot);
      if (profile != null) {
        yield profile;
        return;
      }
      if (snapshot.metadata.isFromCache) continue;
      if (snapshot.exists) {
        throw const FormatException('Invalid account weight');
      }
      yield null;
      return;
    }
  }

  @override
  Future<void> createIfMissing(String uid, AccountProfile profile) async {
    _requireActiveUser(uid);
    if (!AccountProfile.acceptsWeight(profile.bodyWeightKg)) {
      throw ArgumentError('Invalid account weight');
    }
    final document = _document(uid);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(document);
      _requireActiveUser(uid);
      if (snapshot.exists) {
        if (_readProfile(snapshot) == null) {
          throw const FormatException('Invalid account weight');
        }
        return;
      }
      transaction.set(document, {'bodyWeightKg': profile.bodyWeightKg});
    });
    _requireActiveUser(uid);
    // A committed transaction can leave the persistent cache empty.
    unawaited(_populateCache(document));
  }

  DocumentReference<Map<String, dynamic>> _document(String uid) =>
      _firestore.collection('users').doc(uid);

  AccountProfile? _readProfile(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final weight = snapshot.data()?['bodyWeightKg'];
    return weight is num && AccountProfile.acceptsWeight(weight)
        ? AccountProfile(bodyWeightKg: weight.toDouble())
        : null;
  }

  void _requireActiveUser(String uid) {
    if (_auth.currentUser?.uid != uid) throw StateError('Account changed');
  }

  Future<void> _populateCache(
    DocumentReference<Map<String, dynamic>> document,
  ) async {
    try {
      await document.get();
    } catch (error) {
      LoggerService.warning(
        'Account cache read failed (${error.runtimeType}).',
      );
    }
  }
}

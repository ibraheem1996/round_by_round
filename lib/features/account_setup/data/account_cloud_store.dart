import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../account_profile.dart';

typedef CloudAccount = ({AccountProfile? profile, bool exists, bool confirmed});

abstract interface class AccountCloudStore {
  Stream<CloudAccount> watch(String uid);
  Future<void> createIfMissing(String uid, AccountProfile profile);
}

@LazySingleton(as: AccountCloudStore)
final class FirestoreAccountCloudStore implements AccountCloudStore {
  FirestoreAccountCloudStore(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DocumentReference<Map<String, dynamic>> _document(String uid) =>
      _firestore.collection('users').doc(uid);

  @override
  Stream<CloudAccount> watch(String uid) => _document(uid)
      .snapshots(includeMetadataChanges: true)
      .map((snapshot) {
        final value = snapshot.data()?['bodyWeightKg'];
        return (
          profile: value is num && AccountProfile.acceptsWeight(value)
              ? AccountProfile(bodyWeightKg: value.toDouble())
              : null,
          exists: snapshot.exists,
          confirmed:
              !snapshot.metadata.isFromCache &&
              !snapshot.metadata.hasPendingWrites,
        );
      });

  @override
  Future<void> createIfMissing(String uid, AccountProfile profile) async {
    if (_auth.currentUser?.uid != uid) return;
    final document = _document(uid);
    // A server read respects the SDK's offline mode before starting a transaction.
    final current = await document.get(const GetOptions(source: Source.server));
    if (current.exists || _auth.currentUser?.uid != uid) return;
    // A second device may finish setup between the routing check and this write.
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(document);
      if (_auth.currentUser?.uid == uid && !snapshot.exists) {
        transaction.set(document, {'bodyWeightKg': profile.bodyWeightKg});
      }
    });
  }
}

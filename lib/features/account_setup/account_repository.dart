import 'account_profile.dart';

abstract interface class AccountRepository {
  /// Emits one result, with null only for a server-confirmed missing account.
  Stream<AccountProfile?> check(String uid);

  /// Completes after the server creates or confirms an existing valid account.
  Future<void> createIfMissing(String uid, AccountProfile profile);
}

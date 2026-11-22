import 'account_profile.dart';

abstract interface class AccountRepository {
  /// Emits null only when the backend confirms that setup is missing.
  Stream<AccountProfile?> watch(String uid);

  /// Completes once the weight is durably saved on this device.
  Future<void> save(String uid, AccountProfile profile);
}

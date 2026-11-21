enum SignInProvider { google, apple }

enum SignInResult {
  success,
  canceled,
  networkError,
  serviceUnavailable,
  accountConflict,
  failed,
}

abstract interface class AuthGateway {
  /// Emits the restored session first, followed by changes to the signed-in UID.
  Stream<String?> watchUserId();

  Future<SignInResult> signIn(SignInProvider provider);
}

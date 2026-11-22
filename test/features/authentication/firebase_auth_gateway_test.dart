import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:round_by_round/features/authentication/auth_gateway.dart';
import 'package:round_by_round/features/authentication/data/firebase_auth_gateway.dart';

void main() {
  test('exchanges the Google ID token and initializes Google once', () async {
    final firebase = _Firebase();
    final google = _Google();
    final gateway = FirebaseAuthGateway(firebase, google);

    expect(await gateway.signIn(SignInProvider.google), SignInResult.success);
    expect(google.initializations, 1);
    expect(firebase.googleCredential?.providerId, 'google.com');
    expect(firebase.googleCredential?.idToken, 'test-id-token');

    google.idToken = null;
    firebase.googleCredential = null;
    expect(
      await gateway.signIn(SignInProvider.google),
      SignInResult.serviceUnavailable,
    );
    expect(google.initializations, 1);
    expect(firebase.googleCredential, isNull);
  });

  test(
    'calls the Firebase Apple provider and translates SDK outcomes',
    () async {
      final firebase = _Firebase();
      final google = _Google();
      final gateway = FirebaseAuthGateway(firebase, google);

      expect(await gateway.signIn(SignInProvider.apple), SignInResult.success);
      expect(firebase.appleProvider, isA<AppleAuthProvider>());

      for (final code in ['canceled', 'web-context-canceled']) {
        firebase.appleErrorCode = code;
        expect(
          await gateway.signIn(SignInProvider.apple),
          SignInResult.canceled,
        );
      }

      firebase.appleErrorCode = 'network-request-failed';
      expect(
        await gateway.signIn(SignInProvider.apple),
        SignInResult.networkError,
      );
      expect(google.initializations, 0);
    },
  );
}

final class _Firebase extends Fake implements FirebaseAuth {
  OAuthCredential? googleCredential;
  AuthProvider? appleProvider;
  String? appleErrorCode;

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    googleCredential = credential as OAuthCredential;
    return _Credential();
  }

  @override
  Future<UserCredential> signInWithProvider(AuthProvider provider) async {
    appleProvider = provider;
    final code = appleErrorCode;
    if (code != null) throw FirebaseAuthException(code: code);
    return _Credential();
  }
}

final class _Credential extends Fake implements UserCredential {}

final class _Google extends Fake implements GoogleSignIn {
  int initializations = 0;
  String? idToken = 'test-id-token';

  @override
  Future<void> initialize({
    String? clientId,
    String? serverClientId,
    String? nonce,
    String? hostedDomain,
  }) async {
    initializations++;
  }

  @override
  Future<GoogleSignInAccount> authenticate({
    List<String> scopeHint = const [],
  }) async => _Account(GoogleSignInAuthentication(idToken: idToken));
}

final class _Account extends Fake implements GoogleSignInAccount {
  _Account(this.authentication);

  @override
  final GoogleSignInAuthentication authentication;
}

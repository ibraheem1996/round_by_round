import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../core/services/logger_service.dart';
import '../auth_gateway.dart';

@LazySingleton(as: AuthGateway)
final class FirebaseAuthGateway implements AuthGateway {
  FirebaseAuthGateway(this._auth, this._google);

  final FirebaseAuth _auth;
  final GoogleSignIn _google;
  Future<void>? _googleInitialization;

  @override
  Stream<String?> watchUserId() =>
      _auth.authStateChanges().map((user) => user?.uid).distinct();

  @override
  Future<SignInResult> signIn(SignInProvider provider) async {
    try {
      switch (provider) {
        case SignInProvider.google:
          await _initializeGoogle();
          final account = await _google.authenticate();
          final idToken = account.authentication.idToken;
          if (idToken == null || idToken.isEmpty) {
            LoggerService.warning('Google sign-in returned no ID token.');
            return SignInResult.serviceUnavailable;
          }
          await _auth.signInWithCredential(
            GoogleAuthProvider.credential(idToken: idToken),
          );
        case SignInProvider.apple:
          await _auth.signInWithProvider(AppleAuthProvider());
      }
      return SignInResult.success;
    } on GoogleSignInException catch (error) {
      if (error.code != GoogleSignInExceptionCode.canceled) {
        LoggerService.warning('Google sign-in failed (${error.code.name}).');
      }
      return switch (error.code) {
        GoogleSignInExceptionCode.canceled => SignInResult.canceled,
        GoogleSignInExceptionCode.clientConfigurationError ||
        GoogleSignInExceptionCode.providerConfigurationError =>
          SignInResult.serviceUnavailable,
        _ => SignInResult.failed,
      };
    } on FirebaseAuthException catch (error) {
      final result = switch (error.code) {
        'canceled' || 'web-context-canceled' => SignInResult.canceled,
        'network-request-failed' => SignInResult.networkError,
        'account-exists-with-different-credential' ||
        'credential-already-in-use' => SignInResult.accountConflict,
        'operation-not-allowed' ||
        'app-not-authorized' ||
        'configuration-not-found' => SignInResult.serviceUnavailable,
        _ => SignInResult.failed,
      };
      if (result != SignInResult.canceled) {
        LoggerService.warning('Firebase sign-in failed (${error.code}).');
      }
      return result;
    } on PlatformException catch (error) {
      LoggerService.warning('Sign-in platform call failed (${error.code}).');
      return switch (error.code) {
        'NSURLErrorDomain: -1009' ||
        'NSURLErrorDomain: -1001' ||
        'NSURLErrorDomain: -1005' ||
        'network_error' => SignInResult.networkError,
        _ => SignInResult.failed,
      };
    }
  }

  Future<void> _initializeGoogle() async {
    try {
      await (_googleInitialization ??= _google.initialize());
    } catch (_) {
      _googleInitialization = null;
      rethrow;
    }
  }
}

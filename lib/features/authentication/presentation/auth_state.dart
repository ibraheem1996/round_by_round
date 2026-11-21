import '../auth_gateway.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthRestoring extends AuthState {
  const AuthRestoring();
}

final class AuthUnavailable extends AuthState {
  const AuthUnavailable();
}

final class AuthSignedOut extends AuthState {
  const AuthSignedOut({this.error});

  final SignInResult? error;
}

final class AuthSigningIn extends AuthState {
  const AuthSigningIn();
}

final class AuthSignedIn extends AuthState {
  const AuthSignedIn(this.uid);

  final String uid;
}

import 'dart:async';

import 'package:round_by_round/app/app.dart';
import 'package:round_by_round/features/authentication/auth_gateway.dart';
import 'package:round_by_round/features/authentication/presentation/auth_cubit.dart';
import 'package:round_by_round/features/onboarding/data/onboarding_completion.dart';

import 'test_preferences.dart';

final class TestAuthGateway implements AuthGateway {
  TestAuthGateway({this.userId, this.delayInitialEvent = false});

  final _sessions = <StreamController<String?>>{};
  String? userId;
  bool delayInitialEvent;
  final calls = <SignInProvider>[];
  Future<SignInResult> Function()? onSignIn;

  @override
  Stream<String?> watchUserId() {
    late final StreamController<String?> session;
    session = StreamController<String?>(
      onListen: () {
        _sessions.add(session);
        if (!delayInitialEvent) session.add(userId);
      },
      onCancel: () async {
        _sessions.remove(session);
      },
    );
    return session.stream;
  }

  @override
  Future<SignInResult> signIn(SignInProvider provider) async {
    calls.add(provider);
    return await onSignIn?.call() ?? SignInResult.canceled;
  }

  void emitSession(String? userId) {
    this.userId = userId;
    for (final session in _sessions) {
      session.add(userId);
    }
  }

  void failSession() {
    for (final session in _sessions) {
      session.addError(Exception('Session unavailable'));
    }
  }

  Future<void> close() async {
    await Future.wait(_sessions.toList().map((session) => session.close()));
  }
}

MainApp testApp(TestPreferences preferences, TestAuthGateway gateway) =>
    MainApp(
      initialize: () async => (
        onboardingCompletion: OnboardingCompletion(preferences),
        authCubit: AuthCubit(gateway),
      ),
    );

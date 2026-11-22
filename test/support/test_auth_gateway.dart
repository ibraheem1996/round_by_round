import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:round_by_round/app/startup/app_startup.dart';
import 'package:round_by_round/features/account_setup/account_profile.dart';
import 'package:round_by_round/features/account_setup/account_repository.dart';
import 'package:round_by_round/features/account_setup/presentation/account_setup_cubit.dart';
import 'package:round_by_round/features/authentication/auth_gateway.dart';
import 'package:round_by_round/features/authentication/presentation/login/login_cubit.dart';
import 'package:round_by_round/features/authentication/presentation/session/session_cubit.dart';
import 'package:round_by_round/features/onboarding/data/onboarding_intro_completion.dart';

import 'test_preferences.dart';

final class TestAuthGateway implements AuthGateway {
  TestAuthGateway({this.userId, this.delayInitialEvent = false});

  final _sessions = <StreamController<String?>>{};
  String? userId;
  bool delayInitialEvent;
  final calls = <SignInProvider>[];
  Future<SignInResult> Function()? onSignIn;

  int get sessionListeners => _sessions.length;

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

BlocProvider<SessionCubit> testApp(
  TestPreferences preferences,
  TestAuthGateway gateway, {
  Future<void> Function()? beforeInitialize,
  AccountRepository? accounts,
}) => BlocProvider(
  create: (_) => SessionCubit(gateway),
  child: AppStartup(
    initialize: () async {
      await beforeInitialize?.call();
    },
    getIntroCompletion: () => OnboardingIntroCompletion(preferences),
    createLogin: () => LoginCubit(gateway),
    createAccountSetup: () =>
        AccountSetupCubit(accounts ?? TestAccountRepository()),
  ),
);

final class TestAccountRepository implements AccountRepository {
  TestAccountRepository({
    this.profile = const AccountProfile(bodyWeightKg: 80),
  });

  AccountProfile? profile;
  final saves = <(String, AccountProfile)>[];
  Future<void> Function()? beforeSave;

  @override
  Stream<AccountProfile?> watch(String uid) => Stream.value(profile);

  @override
  Future<void> save(String uid, AccountProfile profile) async {
    saves.add((uid, profile));
    await beforeSave?.call();
    this.profile = profile;
  }
}

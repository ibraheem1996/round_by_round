// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/account_setup/account_repository.dart' as _i158;
import '../../features/account_setup/data/account_cloud_store.dart' as _i701;
import '../../features/account_setup/data/account_recovery_store.dart'
    as _i1006;
import '../../features/account_setup/data/local_first_account_repository.dart'
    as _i473;
import '../../features/account_setup/presentation/account_setup_cubit.dart'
    as _i778;
import '../../features/authentication/auth_gateway.dart' as _i401;
import '../../features/authentication/data/firebase_auth_gateway.dart' as _i457;
import '../../features/authentication/presentation/login/login_cubit.dart'
    as _i514;
import '../../features/onboarding/data/onboarding_intro_completion.dart'
    as _i1036;
import '../startup/app_entry_cubit.dart' as _i993;
import 'firebase_module.dart' as _i616;
import 'preferences_module.dart' as _i816;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    final preferencesModule = _$PreferencesModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.auth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i116.GoogleSignIn>(() => firebaseModule.google);
    gh.lazySingleton<_i460.SharedPreferencesAsync>(
      () => preferencesModule.preferences,
    );
    gh.lazySingleton<_i1006.AccountRecoveryStore>(
      () => _i1006.AccountRecoveryStore(),
    );
    gh.lazySingleton<_i1036.OnboardingIntroCompletion>(
      () =>
          _i1036.OnboardingIntroCompletion(gh<_i460.SharedPreferencesAsync>()),
    );
    gh.lazySingleton<_i701.AccountCloudStore>(
      () => _i701.FirestoreAccountCloudStore(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i158.AccountRepository>(
      () => _i473.LocalFirstAccountRepository(
        gh<_i1006.AccountRecoveryStore>(),
        gh<_i701.AccountCloudStore>(),
      ),
    );
    gh.lazySingleton<_i401.AuthGateway>(
      () => _i457.FirebaseAuthGateway(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.factoryParam<_i778.AccountSetupCubit, String, dynamic>(
      (uid, _) => _i778.AccountSetupCubit(gh<_i158.AccountRepository>(), uid),
    );
    gh.factoryParam<_i993.AppEntryCubit, bool, _i993.SaveIntro>(
      (introCompleted, persistIntro) => _i993.AppEntryCubit(
        gh<_i401.AuthGateway>(),
        gh<_i158.AccountRepository>(),
        introCompleted,
        persistIntro,
      ),
    );
    gh.factory<_i514.LoginCubit>(
      () => _i514.LoginCubit(gh<_i401.AuthGateway>()),
    );
    return this;
  }
}

class _$FirebaseModule extends _i616.FirebaseModule {}

class _$PreferencesModule extends _i816.PreferencesModule {}

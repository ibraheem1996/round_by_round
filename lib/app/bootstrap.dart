import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/services/logger_service.dart';
import '../features/account_setup/account_repository.dart';
import '../features/account_setup/presentation/account_setup_cubit.dart';
import '../features/authentication/auth_gateway.dart';
import '../features/authentication/presentation/login/login_cubit.dart';
import '../features/exercises/presentation/catalog/exercise_catalog_cubit.dart';
import '../features/onboarding/data/onboarding_intro_completion.dart';
import '../firebase_options.dart';
import 'app.dart';
import 'di/app_dependencies.dart';
import 'startup/app_entry_cubit.dart';
import 'startup/app_startup.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseInitialized = false;
  runApp(
    AppStartup(
      prepare: () async {
        if (!firebaseInitialized) {
          await _initializeFirebase();
          firebaseInitialized = true;
        }
        final dependencies = configureDependencies();
        final intro = dependencies<OnboardingIntroCompletion>();
        final introCompleted = await intro.read();

        final entry = AppEntryCubit(
          dependencies<AuthGateway>(),
          dependencies<AccountRepository>(),
          introCompleted,
          intro.save,
        );
        return BlocProvider<AppEntryCubit>(
          create: (_) => entry..start(),
          child: MainApp(
            createExerciseCatalog: () => dependencies<ExerciseCatalogCubit>(),
            createLogin: () => dependencies<LoginCubit>(),
            createAccountSetup: (uid) =>
                dependencies<AccountSetupCubit>(param1: uid),
          ),
        );
      },
    ),
  );
}

Future<void> _initializeFirebase() async {
  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  LoggerService.info(
    'Firebase initialized for ${firebaseApp.options.projectId} '
    '(${firebaseApp.options.appId}).',
  );
}

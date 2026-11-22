import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/services/logger_service.dart';
import '../features/authentication/presentation/login/login_cubit.dart';
import '../features/authentication/presentation/session/session_cubit.dart';
import '../features/onboarding/data/onboarding_intro_completion.dart';
import '../firebase_options.dart';
import 'di/app_dependencies.dart';
import 'startup/app_startup.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();

  late final dependencies = configureDependencies();

  runApp(
    BlocProvider<SessionCubit>(
      create: (_) => dependencies<SessionCubit>(),
      child: AppStartup(
        initialize: _initializeFirebase,
        createLogin: () => dependencies<LoginCubit>(),
        getIntroCompletion: () => dependencies<OnboardingIntroCompletion>(),
      ),
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

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../core/services/logger_service.dart';
import '../features/authentication/presentation/auth_cubit.dart';
import '../features/onboarding/data/onboarding_completion.dart';
import '../firebase_options.dart';
import 'app.dart';
import 'di/app_dependencies.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp(initialize: _initialize));
}

Future<AppStartup> _initialize() async {
  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  LoggerService.info(
    'Firebase initialized for ${firebaseApp.options.projectId} '
    '(${firebaseApp.options.appId}).',
  );
  final dependencies = configureDependencies();
  return (
    onboardingCompletion: dependencies<OnboardingCompletion>(),
    authCubit: dependencies<AuthCubit>(),
  );
}

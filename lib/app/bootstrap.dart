import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../core/services/logger_service.dart';
import '../features/onboarding/data/onboarding_completion.dart';
import '../firebase_options.dart';
import 'app.dart';
import 'di/app_dependencies.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  LoggerService.info(
    'Firebase initialized for ${firebaseApp.options.projectId} '
    '(${firebaseApp.options.appId}).',
  );
  final dependencies = configureDependencies();
  runApp(MainApp(onboardingCompletion: dependencies<OnboardingCompletion>()));
}

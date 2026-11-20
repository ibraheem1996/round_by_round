import 'package:flutter/widgets.dart';

import '../features/onboarding/data/onboarding_completion.dart';
import 'app.dart';
import 'di/app_dependencies.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = configureDependencies();
  runApp(MainApp(onboardingCompletion: dependencies<OnboardingCompletion>()));
}

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/data/onboarding_completion.dart';

final appDependencies = _createDependencies();

GetIt _createDependencies() {
  final dependencies = GetIt.asNewInstance();
  dependencies.registerLazySingleton<SharedPreferencesAsync>(
    SharedPreferencesAsync.new,
  );
  dependencies.registerLazySingleton<OnboardingCompletion>(
    () => OnboardingCompletion(dependencies<SharedPreferencesAsync>()),
  );
  return dependencies;
}

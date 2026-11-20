import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class OnboardingCompletion {
  const OnboardingCompletion(this._preferences);

  static const _key = 'onboarding_complete_v1';
  final SharedPreferencesAsync _preferences;

  Future<bool> read() async {
    try {
      return await _preferences.getBool(_key) ?? false;
    } on Exception {
      return false;
    }
  }

  Future<void> save() => _preferences.setBool(_key, true);
}

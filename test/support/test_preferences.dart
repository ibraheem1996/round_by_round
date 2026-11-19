import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestPreferences extends Fake implements SharedPreferencesAsync {
  TestPreferences({bool completed = false, this.beforeWrite})
    : values = {'onboarding_complete_v1': completed};

  final Future<void>? beforeWrite;
  final Map<String, bool> values;
  final _writtenKeys = <String>[];

  int get writes => _writtenKeys.length;

  @override
  Future<bool?> getBool(String key) async => values[key];

  @override
  Future<void> setBool(String key, bool value) async {
    _writtenKeys.add(key);
    await beforeWrite;
    values[key] = value;
  }
}

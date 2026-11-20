import 'package:shared_preferences/shared_preferences.dart';

class PrefsStorage {
  PrefsStorage(this._prefs);

  final SharedPreferences _prefs;

  // ---------- String ----------
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (_) {
      return false;
    }
  }

  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (_) {
      return null;
    }
  }

  // ---------- int ----------
  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (_) {
      return false;
    }
  }

  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (_) {
      return null;
    }
  }

  // ---------- bool ----------
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (_) {
      return false;
    }
  }

  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (_) {
      return null;
    }
  }

  // ---------- double ----------
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (_) {
      return false;
    }
  }

  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (_) {
      return null;
    }
  }

  // ---------- common ----------
  bool containsKey(String key) {
    try {
      return _prefs.containsKey(key);
    } catch (_) {
      return false;
    }
  }

  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (_) {
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (_) {
      return false;
    }
  }
}

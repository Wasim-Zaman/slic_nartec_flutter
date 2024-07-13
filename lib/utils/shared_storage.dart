import 'package:shared_preferences/shared_preferences.dart';

class SharedStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String token) async {
    if (_prefs != null) {
      await _prefs!.setString('auth_token', token);
    } else {
      throw Exception("SharedPreferences not initialized");
    }
  }

  static String? getToken() {
    return _prefs?.getString('auth_token');
  }

  static Future<void> deleteToken() async {
    if (_prefs != null) {
      await _prefs!.remove('auth_token');
    } else {
      throw Exception("SharedPreferences not initialized");
    }
  }
}

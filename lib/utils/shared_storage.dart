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

  static Future<void> setSlicToken(String token) async {
    if (_prefs != null) {
      await _prefs!.setString('slic_token', token);
    } else {
      throw Exception("SharedPreferences not initialized");
    }
  }

  static Future<void> setCompany(String company) async {
    if (_prefs != null) {
      await _prefs!.setString('company', company);
    } else {
      throw Exception("SharedPreferences not initialized");
    }
  }

  static Future<void> setLocation(String location) async {
    if (_prefs != null) {
      await _prefs!.setString('location', location);
    } else {
      throw Exception("SharedPreferences not initialized");
    }
  }

  static Future<void> setLocationCode(String locationCode) async {
    if (_prefs != null) {
      await _prefs!.setString('location_code', locationCode);
    } else {
      throw Exception("SharedPreferences not initialized");
    }
  }

  static Future<void> setCompanyCode(String companyCode) async {
    if (_prefs != null) {
      await _prefs!.setString('company_code', companyCode);
    } else {
      throw Exception("SharedPreferences not initialized");
    }
  }

  static Future<void> setEmail(String email) async {
    if (_prefs != null) {
      await _prefs!.setString('email', email);
    } else {
      throw Exception("SharedPreferences not initialized");
    }
  }

  static Future<void> setId(String id) async {
    if (_prefs != null) {
      await _prefs!.setString('id', id);
    } else {
      throw Exception("SharedPreferences not initialized");
    }
  }

  static String? getId() {
    return _prefs?.getString('id');
  }

  static String? getLocationCode() {
    return _prefs?.getString('location_code');
  }

  static String? getCompanyCode() {
    return _prefs?.getString('company_code');
  }

  static String? getEmail() {
    return _prefs?.getString('email');
  }

  static String? getCompany() {
    return _prefs?.getString('company');
  }

  static String? getLocation() {
    return _prefs?.getString('location');
  }

  static String? getToken() {
    return _prefs?.getString('auth_token');
  }

  static String? getSlicToken() {
    return _prefs?.getString('slic_token');
  }

  static Future<void> deleteToken() async {
    if (_prefs != null) {
      await _prefs!.remove('auth_token');
    } else {
      throw Exception("SharedPreferences not initialized");
    }
  }

  static Future<void> deleteSlicToken() async {
    if (_prefs != null) {
      await _prefs!.remove('slic_token');
    } else {
      throw Exception("SharedPreferences not initialized");
    }
  }

  // clear method
  static Future<void> clear() async {
    if (_prefs != null) {
      await _prefs!.clear();
    } else {
      throw Exception("SharedPreferences not initialized");
    }
  }
}

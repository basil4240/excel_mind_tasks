import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_persisting_model.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  // Save user to local storage to dummy simulate db call
  Future<void> saveUser(String key, UserPersistingModel value) async {
    await _prefs.setString(key, jsonEncode(value.toJson()));
  }

  // get user to local storage to dummy simulate db call
  UserPersistingModel? getUser(String key) {
    final userJson = _prefs.getString(key);
    if (userJson == null) return null;
    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    return UserPersistingModel.fromJson(userMap);
  }

}

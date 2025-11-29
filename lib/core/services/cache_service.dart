// core/services/cache_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> saveJson(String key, Object value) async {
    return saveString(key, jsonEncode(value));
  }

  Future<dynamic> readJson(String key) async {
    final s = await getString(key);
    if (s == null) return null;
    return jsonDecode(s);
  }
}

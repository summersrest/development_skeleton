import 'dart:convert';
import 'package:development_skeleton/utils/extension.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

///# 键值对存储工具类
///
///## 说明：键值对存储工具类
abstract class SpUtils {
  static SharedPreferences? _sp;

  static setBool(String key, bool value) {
    (_sp ?? Get.find<SharedPreferences>()).setBool(key, value);
  }

  static bool getBool(String key, bool def) {
    return (_sp ?? Get.find<SharedPreferences>()).getBool(key) ?? def;
  }

  static setInt(String key, int value) {
    (_sp ?? Get.find<SharedPreferences>()).setInt(key, value);
  }

  static int getInt(String key, int def) {
    return (_sp ?? Get.find<SharedPreferences>()).getInt(key) ?? def;
  }

  static setString(String key, String value) {
    (_sp ?? Get.find<SharedPreferences>()).setString(key, value);
  }

  static String getString(String key, String def) {
    return (_sp ?? Get.find<SharedPreferences>()).getString(key) ?? def;
  }

  static setDouble(String key, double value) {
    (_sp ?? Get.find<SharedPreferences>()).setDouble(key, value);
  }

  static double getDouble(String key, double def) {
    return (_sp ?? Get.find<SharedPreferences>()).getDouble(key) ?? def;
  }

  static setStringList(String key, List<String> value) {
    (_sp ?? Get.find<SharedPreferences>()).setStringList(key, value);
  }

  static List<String> getStringList(String key) {
    return (_sp ?? Get.find<SharedPreferences>()).getStringList(key) ?? [];
  }

  static setMap(String key, Map<String, dynamic> value) {
    setString(key, json.encode(value).toString());
  }

  static Map<String, dynamic>? getMap(String key) {
    String cache = getString(key, '');
    if (cache.isBlank) return null;
    return json.decode(cache) as Map<String, dynamic>;
  }

}

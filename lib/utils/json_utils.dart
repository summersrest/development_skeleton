import 'dart:convert';

abstract class JsonUtils {
  ///# 是否为Map
  ///
  ///## 说明：是否为Map或者Map<String, dynamic>
  static bool isMap(dynamic any) {
    try {
      if (any is Map || any is Map<String, dynamic>) {
        return true;
      } else if (any is String) {
        return json.decode(any) is Map || json.decode(any) is Map<String, dynamic>;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  ///# 转化为Map<String, dynamic>
  ///
  ///## 说明：将Map格式的字符串或者Map转化为Map<String, dynamic>
  static Map<String, dynamic> any2Map(dynamic any) {
    if (any is Map || any is Map<String, dynamic>) {
      return any.map<String, dynamic>((key, value) => MapEntry(key.toString(), value));
    } else if (json.decode(any) is Map || json.decode(any) is Map<String, dynamic>) {
      return (json.decode(any) as Map).map<String, dynamic>((key, value) => MapEntry(key.toString(), value));
    } else {
      return <String, dynamic>{};
    }
  }

  ///# 是否为List<Map<String, dynamic>>或者List<Map>
  ///
  ///## 说明：是否为List<Map<String, dynamic>>或者List<Map>
  static bool isList(dynamic any) {
    try {
      if (any is List<Map> || any is List<Map<String, dynamic>> || any is List<dynamic>) {
        return true;
      } else if (any is String) {
        return json.decode(any) is List<Map> || json.decode(any) is List<Map<String, dynamic>> || any is List<dynamic>;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  ///# 转化为List<Map<String, dynamic>>
  ///
  ///## 说明：将List<Map>格式的字符串或者List<Map>转化为List<Map<String, dynamic>>
  static List<Map<String, dynamic>> anyToList<T>(dynamic any) {
    if (any is List) {
      return any.map((e) => any2Map(e)).toList();
    } else if (any is List<Map<String, dynamic>>) {
      return any.map((e) => any2Map(e)).toList();
    } else if (any is List<Map>) {
      return any.map((e) => any2Map(e)).toList();
    } else if (json.decode(any) is List<dynamic>) {
      return (json.decode(any) as List).map((e) => any2Map(e)).toList();
    } else if (json.decode(any) is List<Map>) {
      return (json.decode(any) as List<Map>).map((e) => any2Map(e)).toList();
    } else if (json.decode(any) is List<Map<String, dynamic>>) {
      return (json.decode(any) as List<Map<String, dynamic>>).map((e) => any2Map(e)).toList();
    } else {
      return [];
    }
  }

  ///# 数据格式转换
  ///
  ///## 说明：将api返回的数据转化为固定格式
  static T anyToType<T>(dynamic any) {
    if ((T == List<int>) || (T == List<double>) || (T == List<bool>) || T == (List<String>)) {
      return _anyToListForSimple<T>(any);
    } else {
      return any as T;
    }
  }

  ///# 转换为简单的List
  ///
  ///## 说明：转换为List<String>、List<int>、List<double> 等
  static T _anyToListForSimple<T>(dynamic any) {
    if (any is List) {
      return _typeCast<T>(any);
    } else if (any is List<Map<String, dynamic>>) {
      return _typeCast<T>(any);
    } else if (any is List<Map>) {
      return _typeCast<T>(any);
    } else if (json.decode(any) is List<dynamic>) {
      return _typeCast<T>(json.decode(any));
    } else if (json.decode(any) is List<Map>) {
      return _typeCast<T>(json.decode(any));
    } else if (json.decode(any) is List<Map<String, dynamic>>) {
      return _typeCast<T>(json.decode(any));
    } else {
      return [] as T;
    }
  }

  static T _typeCast<T>(List any) {
    if (T == List<int>) {
      return any.map((e) => e as int).toList() as T;
    } else if (T == List<double>) {
      return any.map((e) => e as double).toList() as T;
    } else if (T == List<bool>) {
      return any.map((e) => e as bool).toList() as T;
    } else {
      return any.map((e) => e as String).toList() as T;
    }
  }
}

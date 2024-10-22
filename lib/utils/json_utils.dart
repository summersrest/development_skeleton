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
  static Map<String, dynamic> anyToMap(dynamic any) {
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
        return json.decode(any) is List<Map> ||
            json.decode(any) is List<Map<String, dynamic>> ||
            json.decode(any) is List<dynamic>;
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
      return any.map((e) => anyToMap(e)).toList();
    } else if (any is List<Map<String, dynamic>>) {
      return any.map((e) => anyToMap(e)).toList();
    } else if (any is List<Map>) {
      return any.map((e) => anyToMap(e)).toList();
    } else if (json.decode(any) is List<dynamic>) {
      return (json.decode(any) as List).map((e) => anyToMap(e)).toList();
    } else if (json.decode(any) is List<Map>) {
      return (json.decode(any) as List<Map>).map((e) => anyToMap(e)).toList();
    } else if (json.decode(any) is List<Map<String, dynamic>>) {
      return (json.decode(any) as List<Map<String, dynamic>>).map((e) => anyToMap(e)).toList();
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
    } else if (T == Map<String, dynamic>) {
      return anyToMap(any) as T;
    } else if (T == List<Map<String, dynamic>>) {
      return anyToList(any) as T;
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

  ///# 格式化表达Map
  ///
  ///## 说明：格式化表达Map，将复杂的Map Key拆分成多级的小Map
  ///
  ///@date：2024/10/9
  static Map<String, dynamic>? formatFormMap(Map<String, dynamic>? origin) {
    if (origin == null || origin.isEmpty) return null;
    Map<String, dynamic> targetMap = _inverseJson(origin.keys.toList());
    origin.forEach((key, value) {
      _setValueByPath(path: key, value: value, targetMap: targetMap);
    });
    return targetMap;
  }

  ///# List To Map
  ///
  ///## 说明：
  ///
  ///@date：2024/10/9
  static Map<String, dynamic> _inverseJson(List<String> keys) {
    Map<String, dynamic> map = {};
    List noneList = keys.where((element) => !element.contains('/')).toList();
    if (noneList.isNotEmpty) {
      for (var element in noneList) {
        map[element] = null;
      }
    }
    List<String> originList = keys.where((element) => element.contains('/')).toList();
    if (originList.isEmpty) return map;
    Set startFieldSet = originList.map((e) => e.split('/')[0]).toSet();
    for (var firstField in startFieldSet) {
      map[firstField] = _inverseJson(originList
          .where((element) => element.startsWith(firstField))
          .map((item) => item.substring(firstField.length + 1))
          .toList());
    }
    return map;
  }

  ///# 根据完整的Key设值
  ///
  ///## 说明：
  ///
  ///@date：2024/10/9
  static bool _setValueByPath({
    required String path,
    required dynamic value,
    required Map<String, dynamic> targetMap,
  }) {
    final innermost = _getInnermost(path, targetMap);
    if (innermost is! Map<String, dynamic>) return false;
    path = _removeStartLine(path);
    String key = path.contains("/") ? path.substring(path.lastIndexOf("/") + 1) : path;
    innermost[key] = value;
    return true;
  }

  ///# 获取最内层的Map
  ///
  ///## 说明：
  ///
  ///@date：2024/10/9
  static dynamic _getInnermost(String fullPath, Map<String, dynamic> targetMap, [Map<String, dynamic>? dataSource]) {
    fullPath = _removeStartLine(fullPath);
    if (fullPath.isEmpty) return null;
    final source = dataSource ?? targetMap;
    if (fullPath.contains('/')) {
      String currentPath = fullPath.substring(0, fullPath.indexOf('/'));
      String surplusPath = fullPath.substring(fullPath.indexOf('/') + 1);
      dynamic childSource = source[currentPath];
      if (isMap(childSource)) {
        return _getInnermost(surplusPath, targetMap, childSource);
      }
      return null;
    } else {
      return source;
    }
  }

  ///# 移除最前面的“/”
  ///
  ///## 说明：
  ///
  ///@date：2024/10/9
  static String _removeStartLine(String fullPath) {
    if (!fullPath.startsWith('/')) return fullPath;
    return fullPath.substring(1);
  }

  ///# 根据完整的MapKey获取值
  ///
  ///## 说明：
  ///
  ///@date：2024/10/9
  static dynamic getValueByPath(String? path, Map<String, dynamic> targetMap) {
    if (null == path) return null;
    final innermost = _getInnermost(path, targetMap);
    if (innermost is! Map<String, dynamic>) return false;
    path = _removeStartLine(path);
    String mapKey = path.contains("/") ? path.substring(path.lastIndexOf("/") + 1) : path;
    return innermost[mapKey];
  }
}

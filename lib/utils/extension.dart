///# 字符串扩展
///
///## 说明：字符串扩展
extension StringNullableExtension on String? {
  bool get isBlank {
    if (null == this || this!.trim().isEmpty) return true;
    return false;
  }

  bool get isNotBlank {
    if (null != this && this!.trim().isNotEmpty) return true;
    return false;
  }
}

///# Double扩展
///
///## 说明：Double扩展
extension DoubleExtension on double {

  ///# 删除double末尾无用的0
  ///
  ///## 说明：删除double末尾无用的0，并转为String
  String get deleteUselessZeros {
    RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
    return toString().replaceAll(regex, "") ?? '0';
  }

  ///# 精确到小数点后X位
  ///
  ///## 说明：精确到小数点后X位
  ///
  ///@date：2023/9/29
  String fix(int digits) {
    //为防止四舍五入多保留一位小数
    String fix = toStringAsFixed(digits + 1);
    //截掉多保留的小数
    return fix.substring(0, fix.length - 1);
  }
}


///# List扩展
///
///## 说明：List扩展
extension ListNullableExtension on List? {
  ///# 判断List是否为空
  ///
  ///## 说明：判断List是否为空
  ///
  ///@date：2023/10/7
  bool get isBlank {
    if (null == this || this!.isEmpty) return true;
    return false;
  }

  ///# 判断List是否不为空
  ///
  ///## 说明：判断List是否不为空
  ///
  ///@date：2023/10/7
  bool get isNotBlank {
    if (null != this && this!.isNotEmpty) return true;
    return false;
  }

  ///# Json返回的List解析
  ///
  ///## 说明：将List<Map<String, dynamic>>，转换为实体类列表
  List<T> buildEntity<T>(T Function(Map<String, dynamic> json) callback) {
    if (this == null) return <T>[];
    return this!.map<T>((e) => callback(e)).toList();
  }
}

extension BoolNullableExtension on bool? {
  bool get isTrue {
    if (null != this && this == true) return true;
    return false;
  }

  bool get isFalse {
    if (null == this || this == false) return true;
    return false;
  }
}


extension ObjectExtension<T> on T {
  R let<R>(R Function(T it) fun) {
    return fun(this);
  }
}
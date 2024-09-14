import 'dart:convert';
import 'package:crypto/crypto.dart';

///# MD5工具类
///
///## 说明：MD5工具类
class MD5Utils {
  MD5Utils._();

  ///# 获取MD5值
  static String getMD5(String s) {
    return md5.convert(utf8.encode(s)).toString().toUpperCase();
  }
}

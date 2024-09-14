import 'package:flutter/material.dart';

///# 键盘工具类
///
///## 说明：键盘工具类
abstract class KeyboardUtils {
  ///# 关闭软键盘
  ///
  ///## 说明：关闭软键盘
  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}

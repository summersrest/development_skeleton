import 'package:flutter/material.dart';

///# 屏幕工具类
///
///## 说明：屏幕工具类
abstract class ScreenUtils {
  ///状态栏高度
  ///暂时没有找到完美的获取标题栏高度的方法，可以在一个不存在AppBar的页面，通过[padding.top]获取状态栏高度。
  ///然后在一个存在AppBar的页面，通过[padding.top]获取状态栏+标题栏的高度。
  ///两者相减，可以得到正确的标题栏高度。
  static double? _stateBarHeight;

  ///# 屏幕宽度
  ///
  ///## 说明：屏幕宽度
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  ///# 屏幕高度
  ///
  ///## 说明：屏幕高度
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  ///# 顶部安全区域高度
  ///
  ///## 说明：标题栏+状态栏
  static double getTopPaddingHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  ///# 获取状态栏高度
  ///
  ///## 说明：标题栏+状态栏
  static double getStateBarHeight(BuildContext context) {
    return _stateBarHeight ?? 24;
  }

  ///# 记录状态栏高度
  ///
  ///## 说明：可以在一个不存在AppBar的页面，通过[padding.top]获取状态栏高度。
  ///         然后调用此函数，将高度保存，用以计算标题栏高度
  static double recordStateBarHeight(double height) {
    return _stateBarHeight = height;
  }

  ///# 获取状态栏高度
  ///
  ///## 说明：需要提前记录状态栏高度
  static double getAppBarHeight(BuildContext context) {
    return getTopPaddingHeight(context) - getStateBarHeight(context);
  }
}
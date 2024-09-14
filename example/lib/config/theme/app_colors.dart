import 'package:flutter/material.dart';

///# 自定义颜色
///
///## 说明：预定义的自定义颜色
class AppColors extends ThemeExtension<AppColors> {
  ///　应用程序的底色
  final Color primary;

  ///　用作整体的背景色
  final Color backgroundColor;

  ///　用于错误、提醒注意等想要显眼的地方。
  final Color accent;

  ///　文本颜色
  final Color textColor;

  /// 浅色文本
  final Color textLight;

  /// 深色文本
  final Color textDart;

  /// 分割线颜色
  final Color lineColor;

  const AppColors({
    //　应用程序的底色
    required this.primary,
    //　用作整体的背景色
    required this.backgroundColor,
    //　用于错误
    required this.accent,
    //　浅色文本色
    required this.textLight,
    //　深色文本
    required this.textDart,
    //　文本颜色
    required this.textColor,
    //分割线颜色
    required this.lineColor,
  });

  @override
  ThemeExtension<AppColors> copyWith() {
    return this;
  }

  @override
  ThemeExtension<AppColors> lerp(covariant ThemeExtension<AppColors>? other, double t) {
    return this;
  }

  static AppColors of(BuildContext context) {
    AppColors? paColors = Theme.of(context).extension<AppColors>();
    if (null != paColors) return paColors;
    throw FlutterError('AppColors.of() error');
  }

  static AppColors? maybeOf(BuildContext context) {
    return Theme.of(context).extension<AppColors>();
  }
}

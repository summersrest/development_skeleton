import 'package:development_skeleton/development_skeleton.dart';
import 'package:flutter/material.dart';

///# 主题切换
///
///@date 2024/9/10
class ThemeController extends BaseController {
  /// 主题列表
  List<ThemeItem> themeList = [];

  /// 当前主题
  ThemeItem currentTheme = AppTheme.of().current;

  /// 当前主题模式
  ThemeMode mode = ThemeMode.system;


  @override
  init() {
    //获取主题列表
    themeList = AppTheme.of().themes;
    showContent();
  }

  /// 切换主题
  void changeTheme(ThemeItem theme) {
    currentTheme = theme;
    update();
    //主题切换
    AppTheme.of().changeThemeByName(currentTheme.name);
  }

  /// 切换主题模式
  void changeThemeMode(ThemeMode mode) {
    this.mode = mode;
    update();
    //主题模式切换
    AppTheme.of().changeThemeMode(mode);
  }
}

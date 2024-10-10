import 'package:development_skeleton/core/env_config.dart';
import 'package:development_skeleton/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
export 'package:development_skeleton/utils/extension.dart';

class AppTheme {
  /// 主题列表
  final List<ThemeItem> _themeItems = [
    ThemeItem(
      name: 'default',
      light: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      dark: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
    )
  ];

  /// 当前主题
  late Rx<ThemeItem> _currentTheme;

  AppTheme._({
    String? initTheme,
    List<ThemeItem>? themeItems,
  }) {
    if (themeItems.isNotBlank) {
      _themeItems.clear();
      _themeItems.addAll(themeItems!);
    }
    initTheme ??= 'default';
    _currentTheme = _themeItems
        .firstWhere(
          (item) => item.name == initTheme,
          orElse: () => _themeItems[0],
        )
        .obs;
  }

  ///# 构造器
  ///
  ///## 说明：构造器，构造AppTheme，同时进行缓存。
  factory AppTheme.init({
    String? initTheme,
    List<ThemeItem>? themeItems,
  }) {
    AppTheme appTheme = AppTheme._(
      initTheme: initTheme,
      themeItems: themeItems,
    );
    Get.put(appTheme, permanent: true);
    return appTheme;
  }

  ///# 获取当前主题
  ///
  ///## 说明：获取当前主题
  ///
  ///@date：2024/9/9
  ThemeItem get current => _currentTheme.value;

  ///# 设置主题
  ///
  ///## 说明：通过主题名称，设置主题
  void changeThemeByName(String name) async {
    _currentTheme.value = _themeItems.firstWhere(
      (item) => item.name == name,
      orElse: () => throw Exception('未寻找到相应主题'),
    );
    await Future.delayed(const Duration(milliseconds: 300));
    Get.forceAppUpdate();
  }

  ///# 修改主题模式
  ///
  ///## 说明：修改主题模式
  ///         [themeMode] ThemeMode.system：跟随系统
  ///                     ThemeMode.light： 亮色
  ///                     ThemeMode.dark.： 暗色
  void changeThemeMode(ThemeMode themeMode) {
    Get.changeThemeMode(themeMode);
  }

  ///# 是否深色主题
  ///
  ///## 说明：
  bool get isDarkMode => Get.isDarkMode;

  ///# 主题列表
  ///
  ///## 说明：获取主题列表
  List<ThemeItem> get themes => _themeItems;

  ///# 获取AppTheme实例
  ///
  ///## 说明：获取AppTheme实例
  static AppTheme of() => Get.find();
}

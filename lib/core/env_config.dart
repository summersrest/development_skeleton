import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///# App运行配置项
///
///## 说明：App运行配置项
class EnvConfig {
  /// 项目后台运行时的标题
  final String title;

  /// debug时是否显示横条
  final bool debugShowCheckedModeBanner;

  /// Http配置项
  final List<HttpConfig> httpConfigs;

  /// 是否显示Log（若不做设置，则默认debug显示，release不显示）
  final bool? enableLog;

  /// 设计图尺寸
  final Size designSize;

  /// 异常回调
  final Function({required Object error, required StackTrace? stack}) onExceptionCallback;

  /// 初始路由
  final String initialRoute;

  /// 路由列表
  final List<GetPage> getPages;

  /// 默认路由跳转动画
  final Transition? defaultTransition;

  /// 初始化（启动App之前的初始化函数，可在其中做一些初始化操作）
  final Future<void> Function()? onInit;

  /// 主题配置
  final ThemeConfig? themeConfig;

  /// 国际化配置
  final TranslationConfig? translationConfig;

  /// 构造函数
  EnvConfig({
    /// 项目后台运行时的标题
    required this.title,

    /// Http配置项
    required this.httpConfigs,

    /// debug时是否显示横条
    this.debugShowCheckedModeBanner = false,

    /// 是否显示Log（若不做设置，则默认debug显示，release不显示）
    this.enableLog,

    /// 异常回调
    required this.onExceptionCallback,

    /// 设计图尺寸
    this.designSize = const Size(640, 960),

    /// 初始路由
    required this.initialRoute,

    /// 路由列表
    required this.getPages,

    /// 默认路由跳转动画
    this.defaultTransition,

    /// 初始化
    this.onInit,

    /// 主题配置
    this.themeConfig,

    /// 国际化配置
    this.translationConfig,
  });
}

///# Http请求配置项
///
///## 说明：Http请求配置项
class HttpConfig {
  ///  名称
  final String name;

  /// 请求超时时间
  final int connectTimeout;

  /// 响应超时时间
  final int receiveTimeout;

  /// 是否开启日志
  final bool enableLog;

  /// 域名
  final String baseUrl;

  /// 代理
  final String? proxy;

  /// 拦截器
  final List<Interceptor>? interceptors;

  HttpConfig({
    /// 名称
    required this.name,

    /// 是否开启日志
    required this.enableLog,

    /// 域名
    required this.baseUrl,

    /// 请求超时时间
    this.connectTimeout = 20000,

    /// 响应超时时间
    this.receiveTimeout = 20000,

    /// 代理
    this.proxy,

    /// 拦截器
    this.interceptors,
  });
}

///# 主题配置
///
///## 说明：主题配置
class ThemeConfig {
  /// 主题列表
  final List<ThemeItem>? themeItems;

  /// 初始化主题
  final String? initTheme;

  /// 主题模式（亮色，暗色，跟随系统）
  final ThemeMode? themeMode;

  ThemeConfig({
    /// 主题列表
    this.themeItems,

    /// 初始化主题
    this.initTheme,

    /// 主题模式（亮色，暗色，跟随系统）
    this.themeMode,
  });
}

///# 主题
///
///## 说明：主题
class ThemeItem {
  /// 主题名称
  final String name;

  /// 亮色
  final ThemeData light;

  /// 暗色
  final ThemeData dark;

  const ThemeItem({
    required this.name,
    required this.light,
    required this.dark,
  });
}

///# 国际化配置
///
///## 说明：国际化配置
class TranslationConfig {
  /// 国际化文件
  final Translations? translations;

  /// 指定翻译语言
  final Locale? locale;

  /// 添加一个回调语言选项，以备上面指定的语言翻译不存在
  final Locale? fallbackLocale;

  TranslationConfig({
    /// 国际化文件
    this.translations,

    /// 指定翻译语言
    this.locale,

    /// 添加一个回调语言选项，以备上面指定的语言翻译不存在
    this.fallbackLocale,
  });
}

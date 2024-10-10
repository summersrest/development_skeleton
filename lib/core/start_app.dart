import 'dart:async';
import 'package:development_skeleton/core/env_config.dart';
import 'package:development_skeleton/development_skeleton.dart';
import 'package:development_skeleton/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

///# 启动App
///
///## 说明：启动App
Future startApp(EnvConfig config) async {
  //全局异常捕获
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      //图片显示异常不提示
      if (details.library == 'image resource service') {
        if (details.exception is FlutterError &&
            (details.exception as FlutterError).diagnostics.isNotEmpty &&
            (details.exception as FlutterError).diagnostics.first.value is List) {
          Log.simpleE(((details.exception as FlutterError).diagnostics.first.value as List).first);
        }
        return;
      }
      //将Flutter框架异常重新抛出，交给 Zone 处理
      Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.empty);
    };
    //初始化
    await _init(config);
    //运行app
    _runApp(config);
  }, (error, stack) {
    //异常回调
    config.onExceptionCallback(error: error, stack: stack);
  });
}

///# 初始化
///
///## 说明：1、对SharedPreferences初期化缓存
///        2、HttpHelper实例化
///        3、调用onInit()回调
Future _init(EnvConfig config) async {
  // 初始化SharedPreferences
  await Get.putAsync(() async {
    return await SharedPreferences.getInstance();
  });
  // HttpHelper实例化
  if (config.httpConfigs.isNotEmpty) {
    for (var httpConfig in config.httpConfigs) {
      HttpHelper.from(httpConfig);
    }
  }
  //主题初始化
  AppTheme.init(
    initTheme: config.themeConfig?.initTheme,
    themeItems: config.themeConfig?.themeItems,
  );
  //日志初始化
  Log.enable = config.logConfig?.enableLog ?? isDebug;
  Log.setColors(
    trace: config.logConfig?.trace,
    debug: config.logConfig?.debug,
    info: config.logConfig?.info,
    warning: config.logConfig?.warning,
    error: config.logConfig?.error,
    fatal: config.logConfig?.fatal,
  );
  //初始
  if (null != config.onInit) {
    await config.onInit!();
  }
}

///# 运行App
///
///## 说明：运行App
void _runApp(EnvConfig config) {
  final easyLoading = EasyLoading.init();
  //easyLoading禁止用户交互
  EasyLoading.instance.userInteractions = false;
  runApp(ScreenUtilInit(
    //设计图尺寸
    designSize: config.designSize,
    builder: (BuildContext context, Widget? child) {
      return Obx(
        () => GetMaterialApp(
          title: config.title,
          // locale: config.translationConfig?.locale,
          fallbackLocale: config.translationConfig?.fallbackLocale,
          translations: config.translationConfig?.translations,
          localeListResolutionCallback: (List<Locale>? locales, Iterable<Locale> supportedLocales) {
            if (null != locales && locales.isNotEmpty && null != config.translationConfig?.locale) {
              if (locales.containsMapTo(config.translationConfig?.locale, (e) => e!.languageCode)) {
                Get.locale = config.translationConfig!.locale!;
              } else {
                Get.locale = locales.first;
              }
            } else if (locales.isBlank && null != config.translationConfig?.locale) {
              Get.locale = config.translationConfig!.locale!;
            } else if (null != locales && locales.isNotEmpty && null == config.translationConfig?.locale) {
              Get.locale = locales.first;
            }
          },
          debugShowCheckedModeBanner: config.debugShowCheckedModeBanner,
          themeMode: config.themeConfig?.themeMode ?? ThemeMode.system,
          theme: AppTheme.of().current.light,
          darkTheme: AppTheme.of().current.dark,
          initialRoute: config.initialRoute,
          getPages: config.getPages,
          defaultTransition: config.defaultTransition,
          enableLog: config.logConfig?.enableLog,
          builder: (context, child) {
            child = easyLoading(context, child);
            return MediaQuery(
              //设置文字大小不随系统设置改变
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
              child: GestureDetector(
                child: child,
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
              ),
            );
          },
        ),
      );
    },
  ));

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  }
}

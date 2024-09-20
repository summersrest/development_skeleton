import 'dart:io';

import 'package:development_skeleton/development_skeleton.dart';
import 'package:development_skeleton/widget/show_snack_bar.dart';
import 'package:example/config/translations/translation.dart';
import 'package:flutter/material.dart';
import 'package:example/config/http/my_http_overrides.dart';
import 'package:example/config/http/unpack_interceptor.dart';
import 'package:example/config/routes.dart';
import 'package:example/config/theme/theme_dark.dart';

import 'config/theme/theme_green.dart';

void main() {
  startApp(
    EnvConfig(
        // 项目后台运行时的标题
        title: 'Frame',
        // Http请求配置，可传入多个Http请求实例
        httpConfigs: [
          HttpConfig(
              name: 'apiFox',
              enableLog: true,
              baseUrl: 'https://apifoxmock.com/m1/2234660-1181401-default',
              interceptors: [
                UnpackInterceptor(),
              ])
        ],
        // 主题
        themeConfig: ThemeConfig(
          // 主题
          themeItems: [
            ThemeItem(name: 'green', light: greenThemeLight, dark: greenThemeDark),
            ThemeItem(name: 'black', light: blackThemeLight, dark: blackThemeDark),
          ],
          // 默认主题
          initTheme: 'green',
          // 主题（跟随系统）
          themeMode: ThemeMode.system,
        ),
        //国际化
        translationConfig: TranslationConfig(
          translations: Translation(),
          //不传入则使用手机默认语言
          locale: const Locale('zh', 'CN'),
        ),
        // 初始化路由
        initialRoute: Routes.sample,
        // 路由列表
        getPages: Routes.routes,
        // 程序异常回调
        onExceptionCallback: ({required Object error, required StackTrace? stack}) {
          if (error is HttpHelperException) {
            showSnackBar(error.message);
          } else {
            showSnackBarError(error.toString());
          }
          Log.simpleE("error: $error");
          Log.simpleE("stack: $stack");
        },
        // 初始化（启动App之前的初始化函数，可在其中做一些初始化操作）
        onInit: () async {
          HttpOverrides.global = MyHttpOverrides();
        }),
  );
}

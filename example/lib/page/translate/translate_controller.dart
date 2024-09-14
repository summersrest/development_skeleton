import 'dart:ui';

import 'package:development_skeleton/development_skeleton.dart';
import 'package:get/get.dart';

///# 国际化
///
///@date 2024/9/14 
class TranslateController extends BaseController {

  @override
  init() {

  }

  void changeLocale() {
    if (Get.locale == const Locale('zh', 'CN')) {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('zh', 'CN'));
    }
  }
}
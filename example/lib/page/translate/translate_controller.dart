import 'dart:ui';
import 'package:development_skeleton/development_skeleton.dart';

///# 国际化
///
///@date 2024/9/14 
class TranslateController extends BaseController {

  @override
  init() {

  }

  void changeLocale() {
    if (Translator.of().locale?.languageCode == 'zh') {
      Translator.of().updateLocale(const Locale('en', 'US'));
    } else {
      Translator.of().updateLocale(const Locale('zh', 'CN'));
    }
  }
}
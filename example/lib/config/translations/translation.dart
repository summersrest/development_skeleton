import 'package:example/config/translations/cn.dart';
import 'package:example/config/translations/en.dart';
import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'zh_CN': cn,
    'en_US': en,
  };

}
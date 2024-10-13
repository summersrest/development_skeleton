import 'package:development_skeleton/core/internationalization.dart';


class AppTranslation extends Translation {
  static AppTranslation of() => Translator.of().translation() as AppTranslation;

  /// 国际化
  String international;

  /// 为所有屏幕创造精彩
  String title;

  /// Flutter 为软件开发行业带来了革新：只要一套代码库，即可构建、测试和发布适用于移动、Web、桌面和嵌入式平台的精美应用。
  String content;

  /// 翻译到.....
  String translateTo;

  /// 首页
  String homePage;

  /// 网络请求
  String netWork;

  /// 主题切换
  String themeChange;

  /// 文件存储
  String fileStore;

  AppTranslation({
    required super.languageCode,
    required super.countryCode,
    required this.international,
    required this.title,
    required this.content,
    required this.translateTo,
    required this.homePage,
    required this.netWork,
    required this.themeChange,
    required this.fileStore,
  });
}

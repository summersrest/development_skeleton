import 'package:example/page/main/sample_page.dart';
import 'package:example/page/network/network_page.dart';
import 'package:example/page/store/store_sample_page.dart';
import 'package:example/page/theme/theme_page.dart';
import 'package:get/get.dart';

abstract class Routes {
  ///demo首页
  static const String sample = '/sample';

  ///网络请求
  static const String network = '/network';

  ///主题切换
  static const String theme = '/theme';

  ///国际化
  static const String translate = '/translate';

  ///文件管理
  static const String store = '/store';

  static List<GetPage> routes = [
    GetPage(name: sample, page: () => SamplePage()),
    GetPage(name: network, page: () => NetworkPage()),
    GetPage(name: theme, page: () => ThemePage()),
    GetPage(name: store, page: () => StoreSamplePage()),
  ];
}

import 'package:development_skeleton/development_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:example/config/routes.dart';
import 'package:example/entity/menu_entity.dart';
import 'package:get/get.dart';
import 'package:example/config/translations/app_translation.dart';

///# Demo首页
///
///@date 2024/9/10
class SampleController extends BaseController {
  ///直接声明 GetX无法翻译，需要在页面刷新的时候重新获取。
  // final List<MenuEntity> menus = [
  //   MenuEntity(
  //     name: 'networkRequest'.tr,
  //     iconData: Icons.request_page_outlined,
  //     onTap: () => Get.toNamed(Routes.network),
  //   ),
  //   MenuEntity(
  //     name: 'theme'.tr,
  //     iconData: Icons.phone_iphone_outlined,
  //     onTap: () => Get.toNamed(Routes.theme),
  //   ),
  //   MenuEntity(
  //     name: 'translate'.tr,
  //     iconData: Icons.translate,
  //     onTap: () => Get.toNamed(Routes.translate),
  //   ),
  // ];

  @override
  init() {

  }

  List<MenuEntity> getMenus() => [
        MenuEntity(
          name: AppTranslation.of().netWork,
          iconData: Icons.request_page_outlined,
          onTap: () => Get.toNamed(Routes.network),
        ),
        MenuEntity(
          name: AppTranslation.of().themeChange,
          iconData: Icons.phone_iphone_outlined,
          onTap: () => Get.toNamed(Routes.theme),
        ),
        MenuEntity(
          name: AppTranslation.of().international,
          iconData: Icons.translate,
          onTap: () => Get.toNamed(Routes.translate),
        ),
        MenuEntity(
          name: AppTranslation.of().fileStore,
          iconData: Icons.store_outlined,
          onTap: () => Get.toNamed(Routes.store),
        ),
      ];

  void showLog() async {
    String result = DecimalUtils.addBatch([8.0, 1, 4.5, '3', '哈哈']);
    Log.i(result);
  }
}

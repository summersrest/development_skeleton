import 'package:development_skeleton/development_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:example/config/routes.dart';
import 'package:example/entity/menu_entity.dart';
import 'package:get/get.dart';

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
  init() {}

  List<MenuEntity> getMenus() => [
        MenuEntity(
          name: 'networkRequest'.tr,
          iconData: Icons.request_page_outlined,
          onTap: () => Get.toNamed(Routes.network),
        ),
        MenuEntity(
          name: 'theme'.tr,
          iconData: Icons.phone_iphone_outlined,
          onTap: () => Get.toNamed(Routes.theme),
        ),
        MenuEntity(
          name: 'translate'.tr,
          iconData: Icons.translate,
          onTap: () => Get.toNamed(Routes.translate),
        ),
      ];
}

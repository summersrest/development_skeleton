import 'package:development_skeleton/development_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:example/config/routes.dart';
import 'package:example/entity/menu_entity.dart';
import 'package:get/get.dart';

///# Demo首页
///
///@date 2024/9/10
class SampleController extends BaseController {
  final List<MenuEntity> menus = [
    MenuEntity(
      name: '网络请求',
      iconData: Icons.request_page_outlined,
      onTap: () => Get.toNamed(Routes.network),
    ),
    MenuEntity(
      name: '主题切换',
      iconData: Icons.phone_iphone_outlined,
      onTap: () => Get.toNamed(Routes.theme),
    ),
    MenuEntity(
      name: '国际化',
      iconData: Icons.translate,
      onTap: null,
    ),
  ];

  @override
  init() {}
}


import 'package:development_skeleton/development_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:example/config/theme/app_colors.dart';
import 'package:example/entity/menu_entity.dart';
import 'package:get/get.dart';
import 'sample_controller.dart';

///# Demo首页
///
///@date 2024/9/10
class SamplePage extends BasePage<SampleController> {
  SamplePage({super.key});

  @override
  SampleController initController() => SampleController();

  @override
  Widget build(BuildContext context) {
    List<MenuEntity> menus = ctrl.getMenus();
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'.tr),
        actions: [
          IconButton(
              onPressed: ctrl.showLog,
              icon: const Icon(
                Icons.print,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: menus.length,
        itemBuilder: (BuildContext context, int index) {
          MenuEntity entity = menus[index];
          return ListTile(
            onTap: entity.onTap,
            leading: Icon(
              entity.iconData,
              color: AppColors.of(context).primary,
            ),
            title: Text(entity.name),
            trailing: Icon(
              Icons.keyboard_arrow_right_outlined,
              color: AppColors.of(context).primary,
            ),
          );
        },
      ),
    );
  }
}

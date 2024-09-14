import 'package:development_skeleton/development_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:example/config/theme/app_colors.dart';
import 'package:example/entity/menu_entity.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('首页')),
      body: ListView.builder(
        itemCount: ctrl.menus.length,
        itemBuilder: (BuildContext context, int index) {
          MenuEntity entity = ctrl.menus[index];
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

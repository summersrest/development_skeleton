import 'package:development_skeleton/development_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'translate_controller.dart';

///# 国际化
///
///@date 2024/9/14
class TranslatePage extends BasePage<TranslateController> {
  TranslatePage({super.key});

  @override
  TranslateController initController() => TranslateController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('international'.tr)),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              title: Text('title'.tr),
              subtitle: Text('content'.tr),
            ),
            ElevatedButton(
              onPressed: ctrl.changeLocale,
              child: Text('translateTo'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

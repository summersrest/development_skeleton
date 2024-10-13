import 'package:development_skeleton/development_skeleton.dart';
import 'package:flutter/material.dart';
import 'translate_controller.dart';
import 'package:example/config/translations/app_translation.dart';

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
      appBar: AppBar(title: Text(AppTranslation.of().international)),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              title: Text(AppTranslation.of().title),
              subtitle: Text(AppTranslation.of().content),
            ),
            ElevatedButton(
              onPressed: ctrl.changeLocale,
              child: Text(AppTranslation.of().translateTo),
            ),
          ],
        ),
      ),
    );
  }
}

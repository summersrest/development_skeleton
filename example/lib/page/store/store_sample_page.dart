import 'package:development_skeleton/development_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'store_sample_controller.dart';

///# 文件处理
///
///@date 2024/9/20
class StoreSamplePage extends BasePage<StoreSampleController> {
  StoreSamplePage({super.key});

  @override
  StoreSampleController initController() => StoreSampleController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('文件存储'.tr)),
      body: DividerColumn(
        showDividers: const [ShowDivider.beginning, ShowDivider.middle],
        crossAxisAlignment: CrossAxisAlignment.center,
        dividerHeight: 30,
        children: [
          ElevatedButton(
            onPressed: ctrl.saveToFileOverride,
            child: const Text('字符串写入文件（覆盖）'),
          ),
          ElevatedButton(
            onPressed: ctrl.saveToFile,
            child: const Text('字符串写入文件（追加）'),
          ),
          ElevatedButton(
            onPressed: ctrl.readString,
            child: const Text('从文件中读取字符串'),
          ),
          ElevatedButton(
            onPressed: ctrl.readStringLarge,
            child: const Text('大文件按行读取'),
          ),
          ElevatedButton(
            onPressed: ctrl.readFromResource,
            child: const Text('从资源文件中读取字符串'),
          ),
        ],
      ),
    );
  }
}

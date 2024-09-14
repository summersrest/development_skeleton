import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'base_controller.dart';

///# Page超类
///
///## 说明：如果page为StatelessWidget，直接继承此类。
///        如果需要使用StatefulWidget，可以将StatefulWidget作为子组件使用。
abstract class BasePage<T extends BaseController> extends StatelessWidget {
  BasePage({super.key});

  /// Tag
  late final String? tag = initTag();

  String? initTag() => null;

  /// Controller实例化
  late final T ctrl = Get.put(initController(), tag: tag);

  T initController();

}


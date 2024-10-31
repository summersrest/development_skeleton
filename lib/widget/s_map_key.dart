import 'package:development_skeleton/widget/s_widget.dart';
import 'package:flutter/material.dart';

///# 表单格式拼接组件
///
///## 说明：[SForm]组件可以直接获取子组件的输入表单，但是有时表单数据格式不是简单的单层Map。
///        [SMapKey]可以将其子组件都加入一个Map中。这时需要[SMapKey]组件，将其调整到所需要的格式。
class SMapKey extends SWidget {
  final Widget child;

  const SMapKey({
    super.key,
    required super.mapKey,
    required this.child,
  });

  static SMapKeyState? maybeOf(BuildContext context) {
    if (context.mounted) {
      return context.findAncestorStateOfType();
    }
    return null;
  }

  @override
  State<SMapKey> createState() => SMapKeyState();
}

class SMapKeyState extends SWidgetState<SMapKey> {
  @override
  Widget build(BuildContext context) => widget.child;
}

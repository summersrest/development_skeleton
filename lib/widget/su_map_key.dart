import 'package:development_skeleton/widget/su_widget.dart';
import 'package:flutter/material.dart';

///# 表单格式拼接组件
///
///## 说明：[SUForm]组件可以直接获取子组件的输入表单，但是有时表单数据格式不是简单的单层Map。
///        [SUMapKey]可以将其子组件都加入一个Map中。这时需要[SUMapKey]组件，将其调整到所需要的格式。
class SUMapKey extends SUWidget {
  final Widget child;

  const SUMapKey({
    super.key,
    required super.mapKey,
    required this.child,
  });

  static SUMapKeyState? maybeOf(BuildContext context) {
    if (context.mounted) {
      return context.findAncestorStateOfType();
    }
    return null;
  }

  @override
  State<SUMapKey> createState() => SUMapKeyState();
}

class SUMapKeyState extends SUWidgetState<SUMapKey> {
  @override
  Widget build(BuildContext context) => widget.child;
}

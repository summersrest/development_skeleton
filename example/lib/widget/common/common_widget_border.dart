import 'package:flutter/material.dart';
import 'package:development_skeleton/development_skeleton.dart';

///# 组件边框
///
///## 说明：
class CommonWidgetBorder extends StatelessWidget {
  final double? width;
  final double? height;
  final bool? isError;
  final bool? isFocus;
  final Widget child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;

  const CommonWidgetBorder({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.isFocus,
    this.isError,
    this.alignment,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _getBorderColor(), width: 1.5),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 50,
        ),
        child: child,
      ),
    );
  }

  ///# 获取边框颜色
  ///
  ///## 说明：
  ///
  ///@date：2024/9/29
  Color _getBorderColor() {
    if (isError.isTrue) return Colors.red;
    if (isFocus.isTrue) return Colors.green;
    return Colors.grey;
  }
}

import 'package:development_skeleton/utils/multi_click_utils.dart';
import 'package:flutter/material.dart';

///# InkWell
///
/// 防重复点击
class SInkWell extends StatelessWidget {
  /// 是否防双击
  final bool isPreventDoubleClick;

  /// 未点击时的背景色
  final Color? color;

  /// 圆角
  final BorderRadius? borderRadius;

  /// 允许的点击间隔（毫秒）
  final int intervalMilliseconds;

  final VoidCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureTapCallback? onLongPress;
  final Widget child;

  const SInkWell({
    super.key,
    this.isPreventDoubleClick = true,
    this.onTap,
    this.color,
    this.onDoubleTap,
    this.onLongPress,
    this.borderRadius,
    this.intervalMilliseconds = 500,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: InkWell(
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          borderRadius: borderRadius,
          onTap: isPreventDoubleClick
              ? () {
                  if (!MultiClickUtils.isMultiClick(intervalMilliseconds: intervalMilliseconds) && null != onTap) {
                    onTap?.call();
                  }
                }
              : onTap,
          child: child,
        ),
      ),
    );
  }
}

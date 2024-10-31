import 'package:development_skeleton/utils/multi_click_utils.dart';
import 'package:flutter/material.dart';

///# GestureDetector
///
/// 防重复点击
class SGestureDetector extends GestureDetector {
  SGestureDetector({
    super.key,
    VoidCallback? onTap,
    // 是否防双击
    bool isPreventDoubleClick = true,
    // 允许的点击间隔（毫秒）
    int intervalMilliseconds = 500,
    super.onDoubleTap,
    super.onLongPress,
    super.behavior,
    super.child,
  }) : super(
          onTap: isPreventDoubleClick
              ? () {
                  if (!MultiClickUtils.isMultiClick(intervalMilliseconds: intervalMilliseconds) && null != onTap) {
                    onTap();
                  }
                }
              : onTap,
        );
}

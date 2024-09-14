import 'package:flutter/material.dart';

enum ShowDivider {
  beginning,
  middle,
  end,
}

///# 带分割线的Column
///
///## 说明：带分割线的Column
class DividerColumn extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;
  final double dividerHeight;
  final Color dividerColor;
  final double dividerPadding;
  final double? paddingStart;
  final double? paddingEnd;
  final List<ShowDivider> showDividers;

  const DividerColumn({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.dividerColor = Colors.transparent,
    this.dividerHeight = 1.0,
    this.dividerPadding = 0,
    this.paddingStart,
    this.paddingEnd,
    this.showDividers = const [ShowDivider.middle],
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> result = [];
    //顶部显示分割线
    if (showDividers.contains(ShowDivider.beginning)) {
      result.add(
        Divider(
          thickness: dividerHeight,
          height: dividerHeight,
          color: dividerColor,
          indent: paddingStart ?? dividerPadding,
          endIndent: paddingEnd ?? dividerPadding,
        ),
      );
    }
    for (var i = 0; i < children.length; i++) {
      if (i != 0 && showDividers.contains(ShowDivider.middle)) {
        result.add(
          Divider(
            thickness: dividerHeight,
            color: dividerColor,
            height: dividerHeight,
            indent: paddingStart ?? dividerPadding,
            endIndent: paddingEnd ?? dividerPadding,
          ),
        );
      }
      result.add(children[i]);
    }
    //底部显示分割线
    if (showDividers.contains(ShowDivider.end)) {
      result.add(
        Divider(
          thickness: dividerHeight,
          color: dividerColor,
          height: dividerHeight,
          indent: paddingStart ?? dividerPadding,
          endIndent: paddingEnd ?? dividerPadding,
        ),
      );
    }
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: result,
    );
  }
}

import 'dart:math';

import 'package:development_skeleton/development_skeleton.dart';
import 'package:example/widget/common/common_widget_border.dart';
import 'package:flutter/material.dart';
import 'common/common_listenable_builder.dart';

///# 下拉列表
///
/// 自定义Input类组件Demo
class SUSpinner extends SUInput<SUSpinnerItem, SUSpinnerController> {
  /// 备选数据源
  final List<SUSpinnerItem>? source;

  /// 提示内容
  final String? hint;

  const SUSpinner({
    super.key,
    super.initValue,
    super.mapKey,
    super.validator,
    super.onChange,
    super.controller,
    this.source,
    this.hint,
  });

  @override
  SUInputState<SUSpinnerItem, SUSpinnerController, SUSpinner> createState() => _SUSpinnerState();
}

class _SUSpinnerState extends SUInputState<SUSpinnerItem, SUSpinnerController, SUSpinner> {
  double _rotate = 0.0;

  @override
  SUSpinnerController createController() => SUSpinnerController(source: widget.source ?? []);

  @override
  Widget build(BuildContext context) {
    return CommonListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        return CommonWidgetBorder(
          isError: controller.error,
          alignment: Alignment.centerLeft,
          child: SUInkWell(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              if (mounted) {
                setState(() {
                  _rotate = 1.0;
                });
              }
              _Spinner(
                context,
                checkedItem: controller.value,
                source: controller.source,
                onChecked: (SUSpinnerItem value) {
                  controller.value = value;
                },
                onDismiss: () {
                  if (mounted) {
                    setState(() {
                      _rotate = 0.0;
                    });
                  }
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      controller.value?.label ?? widget.hint ?? '',
                      style: const TextStyle(
                        fontSize: 17,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TweenAnimationBuilder(
                    duration: _animalDuration,
                    tween: Tween(begin: 0.0, end: _rotate * pi),
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: value,
                        child: const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

///# 下拉列表组件控制器
///
/// 自定义Input类组件控制器Demo
class SUSpinnerController extends SUInputController<SUSpinnerItem> {
  /// 备选数据源
  List<SUSpinnerItem> source;

  SUSpinnerController({
    this.source = const [],
  });

  /// 从[SUForm]组件的[initValue]中获取的数据，转为组件所需要的格式
  @override
  void anyToValue(initValue) {
    if (initValue is SUSpinnerItem) {
      value = initValue;
    } else if (JsonUtils.isMap(initValue)) {
      value = SUSpinnerItem.fromJson(JsonUtils.anyToMap(initValue));
    }
  }

  /// 组件的[value]值转换为表单所需的格式
  @override
  Map<String, dynamic>? valueToForm() {
    return value?.toJson();
  }
}

///# 下拉窗
class _Spinner {
  OverlayEntry? _overlayEntry;

  /// 每个Item的高度
  final double _itemExtent = 40;

  /// 弹窗与组件之间的距离
  final double _divider = 5;

  /// 与屏幕边缘的距离
  final double _screenPadding = 30;

  /// 列表内边距
  final double _listViewPadding = 15;

  /// 窗口圆角
  final double _radius = 15;

  _Spinner(
    BuildContext context, {
    SUSpinnerItem? checkedItem,
    required List<SUSpinnerItem> source,
    required ValueChanged<SUSpinnerItem> onChecked,
    VoidCallback? onDismiss,
  }) {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    // 组件尺寸
    var size = renderBox!.size;
    // 组件位置
    var offset = renderBox.localToGlobal(Offset.zero);
    // 下拉弹窗窗体高度
    double height = _itemExtent * source.length + _listViewPadding * 2;
    // 弹窗最大高度约束
    double maxHeight = double.infinity;
    // 组件底部的空间
    double bottomFree = MediaQuery.of(context).size.height - offset.dy - size.height - _divider - _screenPadding;
    // 组件顶部的空间
    double topFree = offset.dy - _divider - _screenPadding;
    double top;
    // 是否在组件顶部显示
    bool isShowOnTop;
    // 底部空间大于窗体高度，在组件底部弹出
    if (bottomFree > height) {
      top = offset.dy + size.height + _divider;
      isShowOnTop = false;
    } else if (topFree > height) {
      // 顶部空间大于窗体高度，在组件顶部弹出
      top = offset.dy - _divider - height;
      isShowOnTop = true;
    } else {
      // 窗体高度超出顶部与底部空间
      if (topFree > bottomFree) {
        maxHeight = topFree;
        top = offset.dy - _divider - maxHeight;
        isShowOnTop = true;
      } else {
        maxHeight = bottomFree;
        top = offset.dy + size.height + _divider;
        isShowOnTop = false;
      }
    }
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return _SpinnerWindow(
        checkedItem: checkedItem,
        source: source,
        onChecked: onChecked,
        onDismiss: () async {
          onDismiss?.call();
          await Future.delayed(_animalDuration);
          _overlayEntry?.remove();
          _overlayEntry?.dispose();
          _overlayEntry = null;
        },
        width: size.width,
        maxHeight: maxHeight,
        radius: _radius,
        offset: Offset(offset.dx, top),
        isShowOnTop: isShowOnTop,
        itemExtent: _itemExtent,
        listViewPadding: _listViewPadding,
      );
    });
    Overlay.of(context).insert(_overlayEntry!);
  }
}

/// 下拉弹窗组件
class _SpinnerWindow extends StatefulWidget {
  /// 选中的item
  final SUSpinnerItem? checkedItem;

  /// 备选item列表
  final List<SUSpinnerItem> source;

  /// 选中点击事件
  final ValueChanged<SUSpinnerItem> onChecked;

  /// 弹窗关闭监听
  final VoidCallback? onDismiss;

  /// 弹窗宽度
  final double width;

  /// 弹窗高度约束
  final double maxHeight;

  /// 弹窗圆角
  final double radius;

  /// 弹窗位置
  final Offset offset;

  /// 弹窗显示方向
  final bool isShowOnTop;

  /// 列表item高度
  final double itemExtent;

  /// 列表上下内边距
  final double listViewPadding;

  const _SpinnerWindow({
    required this.checkedItem,
    required this.source,
    required this.onChecked,
    required this.onDismiss,
    required this.width,
    required this.maxHeight,
    required this.radius,
    required this.offset,
    required this.isShowOnTop,
    required this.itemExtent,
    required this.listViewPadding,
  });

  @override
  State<_SpinnerWindow> createState() => _SpinnerWindowState();
}

const _animalDuration = Duration(milliseconds: 200);

class _SpinnerWindowState extends State<_SpinnerWindow> {
  double _scaleValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return SUGestureDetector(
      onTap: () {
        if (mounted) {
          setState(() {
            _scaleValue = 0;
          });
        }
        widget.onDismiss?.call();
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: widget.offset.dx,
              top: widget.offset.dy,
              width: widget.width,
              child: TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: _scaleValue),
                duration: _animalDuration,
                builder: (BuildContext context, double? value, Widget? child) {
                  return Transform.scale(
                    scaleY: value,
                    alignment: widget.isShowOnTop ? Alignment.bottomCenter : Alignment.topCenter,
                    child: Container(
                      constraints: BoxConstraints(maxHeight: widget.maxHeight),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.radius),
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.grey[300]!),
                      ),
                      child: ListView.builder(
                        itemExtent: widget.itemExtent,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: widget.listViewPadding),
                        itemCount: widget.source.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool isChecked =
                              (null != widget.checkedItem && widget.source[index].id == widget.checkedItem!.id);
                          return Material(
                            color: Colors.transparent,
                            elevation: 0,
                            child: SUGestureDetector(
                              onTap: () async {
                                if (mounted) {
                                  setState(() {
                                    _scaleValue = 0;
                                  });
                                }
                                widget.onChecked.call(widget.source[index]);
                                widget.onDismiss?.call();
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                color: isChecked ? Colors.green : Colors.transparent,
                                child: Text(
                                  widget.source[index].label,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: isChecked ? Colors.white : Colors.black87,
                                    fontSize: 17,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SUSpinnerItem {
  final String id;
  final String label;

  SUSpinnerItem({
    required this.id,
    required this.label,
  });

  factory SUSpinnerItem.fromJson(Map<String, dynamic>? json) => SUSpinnerItem(
        id: json == null || !json.containsKey('id') ? '' : json['id'],
        label: json == null || !json.containsKey('label') ? '' : json['label'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
      };
}

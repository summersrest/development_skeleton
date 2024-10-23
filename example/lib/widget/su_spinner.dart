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
  @override
  SUSpinnerController createController() => SUSpinnerController(source: widget.source ?? []);

  @override
  Widget build(BuildContext context) {
    return CommonListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        return SUInkWell(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          onTap: () => _Spinner(
            context,
            checkedItem: controller.value,
            source: controller.source,
            onChecked: (SUSpinnerItem value) {
              controller.value = value;
            },
          ),
          child: CommonWidgetBorder(
            isError: controller.error,
            alignment: Alignment.centerLeft,
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
                const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 30,
                ),
              ],
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
  OverlayEntry? overlayEntry;

  /// 每个Item的高度
  final double itemExtent = 40;

  /// 弹窗与组件之间的距离
  final double divider = 5;

  /// 与屏幕边缘的距离
  final double screenPadding = 30;

  /// 列表内边距
  final double listViewPadding = 15;

  /// 窗口圆角
  final double radius = 15;

  _Spinner(
    BuildContext context, {
    SUSpinnerItem? checkedItem,
    required List<SUSpinnerItem> source,
    required ValueChanged<SUSpinnerItem> onChecked,
  }) {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    // 组件尺寸
    var size = renderBox!.size;
    // 组件位置
    var offset = renderBox.localToGlobal(Offset.zero);
    // 下拉弹窗窗体高度
    double height = itemExtent * source.length + listViewPadding * 2;
    // 弹窗最大高度约束
    double maxHeight = double.infinity;
    // 组件底部的空间
    double bottomFree = MediaQuery.of(context).size.height - offset.dy - size.height - divider - screenPadding;
    // 组件顶部的空间
    double topFree = offset.dy - divider - screenPadding;
    double? top;
    // 底部空间大于窗体高度，在组件底部弹出
    if (bottomFree > height) {
      top = offset.dy + size.height + divider;
    } else if (topFree > height) {
      // 顶部空间大于窗体高度，在组件顶部弹出
      top = offset.dy - divider - height;
    } else {
      // 窗体高度超出顶部与底部空间
      if (topFree > bottomFree) {
        maxHeight = topFree;
        top = offset.dy - divider - maxHeight;
      } else {
        maxHeight = bottomFree;
        top = offset.dy + size.height + divider;
      }
    }
    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return SUGestureDetector(
        onTap: () => overlayEntry?.remove(),
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: top,
                width: size.width,
                child: Container(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.grey[300]!),
                  ),
                  child: ListView.builder(
                    itemExtent: itemExtent,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: listViewPadding),
                    itemCount: source.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isChecked = (null != checkedItem && source[index].id == checkedItem.id);
                      return Material(
                        color: Colors.transparent,
                        elevation: 0,
                        child: SUGestureDetector(
                          onTap: () {
                            overlayEntry?.remove();
                            onChecked.call(source[index]);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            color: isChecked ? Colors.green : Colors.transparent,
                            child: Text(
                              source[index].label,
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
              ),
            ],
          ),
        ),
      );
    });
    Overlay.of(context).insert(overlayEntry!);
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

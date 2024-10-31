import 'package:development_skeleton/utils/extension.dart';
import 'package:development_skeleton/widget/s_map_key.dart';
import 'package:flutter/material.dart';

///# 超类
///
///## 说明：Form类组件的超类，在State中完成表单Map key的拼接。
abstract class SWidget extends StatefulWidget {
  /// 表单生成的Map Key值
  final String? mapKey;

  const SWidget({
    super.key,
    this.mapKey,
  });
}

abstract class SWidgetState<W extends SWidget> extends State<W> {
  /// 当前组件完整的表单key值
  String? completeMapKey;

  @override
  void initState() {
    super.initState();
    assert(widget.mapKey != '');
    completeMapKey ??= getMapKeys(context, widget.mapKey);
  }

  ///# 获取完成的表单Key值
  ///
  ///## 说明：
  String getMapKeys(BuildContext context, String? mapKey) {
    SMapKeyState? state = SMapKey.maybeOf(context);
    if (null != state) {
      String parentMapPath = state.completeMapKey ?? '';
      if (parentMapPath.isBlank) return mapKey ?? '';
      if (mapKey.isBlank) return parentMapPath;
      return "$parentMapPath/$mapKey";
    }
    return mapKey ?? '';
  }
}

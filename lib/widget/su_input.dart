import 'package:development_skeleton/utils/json_utils.dart';
import 'package:development_skeleton/widget/su_widget.dart';
import 'package:development_skeleton/utils/extension.dart';
import 'package:flutter/material.dart';

///# 输入类组件超类
///
/// 组件可以通过控制器进行输入校验。也可以与[SUForm]组件配合，统一校验。
abstract class SUInput<T, C extends SUInputController<T>> extends SUWidget {
  /// 初始化值
  final T? initValue;

  /// 内容变更监听
  final ValueChanged<T>? onChange;

  /// 输入内容校验监听
  final String? Function(T? t)? validator;

  /// 控制器
  final C? controller;

  const SUInput({
    super.key,
    super.mapKey,
    this.initValue,
    this.onChange,
    this.validator,
    this.controller,
  });
}

abstract class SUInputState<T, C extends SUInputController<T>, W extends SUInput<T, C>> extends SUWidgetState<W> {
  /// 创建本地控制器
  C createController();

  /// 本地控制器，组件未传入控制器时自动实例化。本地控制器跟随组件的回收自动回收。
  C? _localController;

  /// 控制器
  C get controller {
    if (null != widget.controller) {
      return widget.controller!;
    }
    if (null == _localController) {
      _createLocalController();
    }
    return _localController!;
  }

  @override
  void initState() {
    super.initState();
    // 初始化赋值
    controller.anyToValue(widget.initValue);
    // Form组件赋值
    SUFormState? formState = SUForm.maybeOf(context);
    if (null != formState) {
      formState.register(this);
      // 从Form组件中获取初始值.
      Map<String, dynamic>? formValue = formState.widget.initValue;
      if (null != formValue) {
        // 组件赋值
        dynamic initValue = JsonUtils.getValueByPath(completeMapKey, formValue);
        controller.anyToValue(initValue);
      }
      // 保存校验函数，用于组件单独校验。
      controller._validator = widget.validator;
    }
  }

  @override
  void didUpdateWidget(covariant W oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller != null && widget.controller == null) {
        _localController = _createLocalController();
      }
      if (oldWidget.controller == null && widget.controller != null) {
        _localController?.dispose();
        _localController = null;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _localController?.dispose();
    _localController = null;
  }

  C _createLocalController() {
    _localController?.dispose();
    _localController = null;
    _localController = createController();
    return _localController!;
  }

  @override
  void deactivate() {
    SUForm.maybeOf(context)?.unregister(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

///# 控制器
///
/// 输入类组件控制器
abstract class SUInputController<T> extends ChangeNotifier {
  /// 组件值
  T? _value;

  /// 输入内容校验监听
  String? Function(T? t)? _validator;

  /// 组件状态是否异常
  bool? _error;

  bool get error => _error ?? false;

  /// 组件异常信息
  String? errorMessage;

  ///# 设置组件状态是否异常
  ///
  /// 设置组件状态是否异常
  set error(bool isError) {
    _error = isError;
    if (hasListeners) {
      notifyListeners();
    }
  }

  ///# 取值
  ///
  /// 组件取值
  T? get value => _value;

  ///# 赋值
  ///
  /// 组件赋值
  set value(T? newValue) {
    _value = newValue;
    if (hasListeners) {
      notifyListeners();
    }
  }

  ///# 从[SUForm]组件的[initValue]中获取的数据，转为组件所需要的格式
  ///
  /// 组件的初始值可能来源于[SUForm]的[initValue]参数。但是从[initValue]取出来的数据格式，与[SUInput]组件所需要的数据格式
  /// 很可能并不相同。我们需要通过[anyToValue]函数，将取得的数据进行转换。然后再将结果赋给当前组件。
  ///
  /// 例如组件需要的数据为[String]，可以这么做.
  ///
  ///  ```dart
  ///  class XXController extends SUInputController<String> {
  ///     anyToValue(dynamic initValue) {
  ///         value = null != initValue ? initValue.toString() : '';
  ///     }
  ///  }
  ///  ```
  void anyToValue(dynamic initValue);

  ///# 组件的[value]值转换为表单所需的格式
  ///
  /// 此复写函数用于将组件的[value]值转化为表单数据所需格式。一般来说泛型为自定义实体对象或者实体对象列表时需要使用。自定义实
  /// 体对象或者实体对象列表直接放入表单Map中显然是不对的，所以需要此函数将其转换为Map<String, dynamic>
  /// 或者List<Map<String, dynamic>>，然后再放入表单Map中。
  ///
  ///  ```dart
  ///  class XXController extends SUInputController<T> {
  ///     Map<String, dynamic>? valueToForm() {
  ///         if (null == value) return null;
  ///         return value!.toJson();
  ///     }
  ///  }
  ///  ```
  ///
  /// 如果泛型为简单数据格式，也可以通过此函数进行格式转换。例如年龄输入框，组件[value]为[String]，而表单所需数据为[int]。可以通过此
  /// 函数将输入的[String]格式的年龄，转换为[int]。
  ///
  ///  ```dart
  ///  class XXController extends SUInputController<String> {
  ///     int? valueToForm() {
  ///         if (null == value) return null;
  ///         return int.tryParse(value!) ?? 0;
  ///     }
  ///  }
  ///  ```
  ///
  dynamic valueToForm();

  ///# 校验
  ///
  /// 组件输入内容校验，返回为null则校验通过，返回不为null则为未通过信息。
  String? validate() {
    if (null != _validator) {
      errorMessage = _validator!(value);
      error = errorMessage != null;
      return errorMessage;
    }
    return null;
  }
}

///# Form表单组件
///
/// 可以对其内部的[SUInput]组件进行统一校验，同样可以获取内部[SUInput]组件的输入结果，返回一个表单Map。
/// ```dart
/// /// 声明GlobalKey
/// GlobalKey<SUFormState> globalKey = GlobalKey();
///
/// /// 组件
/// SUForm(
///   key: globalKey,
///   child: Column(
///     children: [
///       XxxInputWidget(mapKey: 'userName'),
///       SUMapKey(
///         mapKey: 'userInfo',
///         child: Column(
///           children: [
///             XxxInputWidget(mapKey: 'name'),
///             XxxInputWidget(mapKey: 'passWord'),
///           ],
///         ),
///       ),
///     ],
///   ),
/// )
///
/// /// 校验
/// List<String>? res = globalKey.currentState?.validate();
/// if (null == res) {
///   // 校验通过
/// } else {
///   // 校验未通过
/// }
///
/// /// 获取表单数据
/// List<String>? validateResult = globalKey.currentState?.validate();
/// if (null == validateResult) {
///   Map<String, dynamic>? res = globalKey.currentState?.value;
/// }
/// ```
class SUForm extends StatefulWidget {
  /// 子组件
  final Widget child;

  /// 子组件初始化内容
  final Map<String, dynamic>? initValue;

  const SUForm({
    super.key,
    required this.child,
    this.initValue,
  });

  static SUFormState? maybeOf(BuildContext context) {
    if (context.mounted) {
      return context.findAncestorStateOfType();
    }
    return null;
  }

  @override
  State<SUForm> createState() => SUFormState();
}

class SUFormState extends State<SUForm> {
  final Set<SUInputState> _fields = <SUInputState>{};

  void register(SUInputState field) {
    _fields.add(field);
  }

  void unregister(SUInputState field) {
    _fields.remove(field);
  }

  @override
  Widget build(BuildContext context) => widget.child;

  ///# 子组件输入内容校验
  ///
  /// 调用子组件的[validate]函数，对子组件的输入内容进行校验。
  ///
  /// 返回值：返回为null则校验通过，返回不为null，则为校验未通过的异常信息列表。
  List<String>? validate() {
    List<String> results = [];
    for (final SUInputState field in _fields) {
      String? result = field.controller.validate();
      if (null != result) {
        results.add(result);
      }
    }
    return results.isNotEmpty ? results : null;
  }

  ///# 获取表单数据
  ///
  /// 获取表单数据，表单格式与设置了[mapKey]参数的组件的格式组件树格式相同。
  /// 例如组件树为：
  ///
  /// ```dart
  /// SUForm(
  ///   child: Column(
  ///     children: [
  ///       XxxInputWidget(mapKey: 'userName'),
  ///       SUMapKey(
  ///         mapKey: 'userInfo',
  ///         child: Column(
  ///           children: [
  ///             XxxInputWidget(mapKey: 'name'),
  ///             XxxInputWidget(mapKey: 'passWord'),
  ///           ],
  ///         ),
  ///       ),
  ///     ],
  ///   ),
  /// )
  /// ```
  /// 则获取到的formValue为：
  /// ```json
  /// {
  ///    "userName": "xxx",
  ///    "userInfo": {
  ///       "name": "xxx",
  ///       "age": "xxx"
  ///     }
  /// }
  /// ```
  ///
  /// 返回值：返回为null则校验通过，返回不为null，则为校验未通过的异常信息列表。
  Map<String, dynamic>? get value {
    Map<String, dynamic> originMap = <String, dynamic>{};
    for (final SUInputState field in _fields) {
      if (field.completeMapKey.isNotBlank) {
        originMap[field.completeMapKey!] = field.controller.valueToForm();
      }
    }
    return JsonUtils.formatFormMap(originMap);
  }
}

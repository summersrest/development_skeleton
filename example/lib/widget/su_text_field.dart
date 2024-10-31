import 'package:development_skeleton/development_skeleton.dart';
import 'package:example/widget/common/common_widget_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common/common_listenable_builder.dart';

///# 输入框
///
/// 自定义Input类组件Demo
class SUTextField extends SInput<String, SUTextFieldController> {
  /// 焦点监听
  final ValueChanged<bool>? onFocusChange;

  /// 提示内容
  final String? hint;

  /// 输入类型
  final InputType inputType;

  /// 最大字数
  final int? maxLength;

  /// 是否密码
  final bool isPassword;

  const SUTextField({
    super.key,
    super.initValue,
    super.mapKey,
    super.validator,
    super.controller,
    this.onFocusChange,
    this.hint,
    this.maxLength,
    this.inputType = InputType.text,
    this.isPassword = false,
  });

  @override
  SInputState<String, SUTextFieldController, SUTextField> createState() => _SUTextFieldState();
}

class _SUTextFieldState extends SInputState<String, SUTextFieldController, SUTextField> {
  /// 键盘类型
  TextInputType? _keyboardType;

  /// 输入限制
  List<TextInputFormatter>? _inputFormatters;

  /// 当前是否获取焦点
  bool _isHaveFocus = false;

  @override
  void initState() {
    super.initState();
    // 键盘模式
    _keyboardType = _getTextInputType();
    // 输入内容限制
    _inputFormatters = [
      if (widget.maxLength != null) ...[
        LengthLimitingTextInputFormatter(widget.maxLength!),
      ],
      if (widget.inputType == InputType.digit) ...[
        FilteringTextInputFormatter(RegExp("[0-9-]"), allow: true),
      ],
      if (widget.inputType == InputType.decimal) ...[
        FilteringTextInputFormatter(RegExp("[0-9.-]"), allow: true),
      ],
    ];
    // 焦点监听
    controller.focusNode.addListener(focusListener);
  }

  @override
  void dispose() {
    // 使用的controller为本地controller，则移除焦点监听
    if (widget.controller == null) {
      controller.focusNode.removeListener(focusListener);
    }
    super.dispose();
  }

  ///焦点监听
  void focusListener() {
    if (controller.focusNode.hasFocus != _isHaveFocus && mounted) {
      setState(() {
        _isHaveFocus = controller.focusNode.hasFocus;
        widget.onFocusChange?.call(_isHaveFocus);
      });
    }
  }

  /// 创建本地控制器
  @override
  SUTextFieldController createController() => SUTextFieldController(text: widget.initValue);

  @override
  Widget build(BuildContext context) {
    return CommonListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        return CommonWidgetBorder(
          isError: controller.error,
          isFocus: _isHaveFocus,
          child: TextFormField(
            controller: controller.textEditingController,
            focusNode: controller.focusNode,
            obscureText: widget.isPassword,
            obscuringCharacter: '⬤',
            inputFormatters: _inputFormatters,
            keyboardType: _keyboardType,
            style: TextStyle(
              fontSize: 17,
              letterSpacing: (widget.isPassword && controller.text.isNotBlank) ? 4 : 0,
            ),
            textAlign: TextAlign.start,
            onTapOutside: (event) {
              if (controller.focusNode.hasFocus) {
                controller.focusNode.unfocus();
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              border: InputBorder.none,
              hintText: widget.hint,
            ),
          ),
        );
      },
    );
  }

  /// 获取键盘类型
  TextInputType _getTextInputType() {
    switch (widget.inputType) {
      // 整数
      case InputType.digit:
        return const TextInputType.numberWithOptions(signed: true, decimal: false);
      // 小数
      case InputType.decimal:
        return const TextInputType.numberWithOptions(signed: true, decimal: true);
      //文字
      case InputType.text:
        return TextInputType.multiline;
      default:
        return TextInputType.multiline;
    }
  }
}

///# 控制器
///
/// 自定义Input组件控制器Demo
class SUTextFieldController extends SInputController<String> {
  TextEditingController? _editController;
  FocusNode? _focusNode;

  SUTextFieldController({String? text}) {
    _editController ??= TextEditingController();
    this.text = text;
  }

  String get text => value;

  set text(String? text) {
    value = text;
  }

  /// TextField较为特殊，重写value，从[TextEditingController]中取值
  @override
  String get value => _editController?.text ?? '';

  @override
  set value(String? newValue) {
    _editController?.text = newValue ?? '';
  }

  FocusNode get focusNode => _focusNode ??= FocusNode();

  TextEditingController? get textEditingController => _editController;

  /// [SForm]组件[initValue]转为组件所需要的值
  @override
  void anyToValue(initValue) {
    value = null != initValue ? initValue.toString() : '';
  }

  /// 组件的[value]值转换为表单所需的格式
  @override
  valueToForm() => value;

  @override
  void dispose() {
    super.dispose();
    try {
      _editController?.dispose();
      _editController = null;
      _focusNode?.dispose();
      _focusNode = null;
    } catch (_) {}
  }
}

///# 输入格式
///
///## 说明：输入格式
enum InputType {
  /// 整数
  digit,

  /// 小数
  decimal,

  /// 文字
  text,
}

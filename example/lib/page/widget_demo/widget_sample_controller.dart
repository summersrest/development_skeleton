import 'package:development_skeleton/development_skeleton.dart';
import 'package:example/widget/su_spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

///# 组件Demo
///
///@date 2024/10/23
class WidgetSampleController extends SUController {
  GlobalKey<SUFormState> globalKey = GlobalKey();
  List<SUSpinnerItem> articles = [
    SUSpinnerItem(id: '0', label: '坟'),
    SUSpinnerItem(id: '1', label: '华盖集'),
    SUSpinnerItem(id: '2', label: '续编的续编'),
    SUSpinnerItem(id: '3', label: '三闲集'),
    SUSpinnerItem(id: '4', label: '二心集'),
    SUSpinnerItem(id: '5', label: '伪自由书'),
    SUSpinnerItem(id: '6', label: '且介亭杂文'),
    SUSpinnerItem(id: '7', label: '集外集拾遗'),
  ];

  final res = {
    'userName': 'root',
    'passWord': 'root',
    'userInfo': {
      'name': null,
      'passWord': 1,
    },
    'article': {
      'id': '6',
      'label': '且介亭杂文',
    }
  };

  @override
  init() {
    showContent();
  }

  /// 校验
  void validate() {
    List<String>? res = globalKey.currentState?.validate();
    if (null != res) {
      Log.i(res);
    } else {
      EasyLoading.showToast('校验通过');
    }
  }

  /// 获取Form表单数据
  void formValue() {
    if (globalKey.currentState?.validate() == null) {
      final res = globalKey.currentState?.value;
      Log.i(res);
    } else {
      EasyLoading.showToast('校验未通过');
    }
  }
}

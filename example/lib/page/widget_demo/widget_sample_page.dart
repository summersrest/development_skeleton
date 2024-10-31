import 'package:development_skeleton/development_skeleton.dart';
import 'package:example/widget/su_spinner.dart';
import 'package:example/widget/su_text_field.dart';
import 'package:flutter/material.dart';
import 'widget_sample_controller.dart';

///# 组件Demo
///
///@date 2024/10/23
class WidgetSamplePage extends SPage<WidgetSampleController> {
  WidgetSamplePage({super.key});

  @override
  WidgetSampleController initController() => WidgetSampleController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('组件'),
        actions: [
          IconButton(
            onPressed: ctrl.validate,
            icon: const Icon(Icons.check),
          ),
          IconButton(
            onPressed: ctrl.formValue,
            icon: const Icon(Icons.data_object_rounded),
          ),
        ],
      ),
      body: MultiStateView(
        controller: ctrl,
        contentBuilder: () {
          return ListView.builder(
            itemCount: 50,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SUTextField(

                ),
              );
            },
          );
          return SForm(
            key: ctrl.globalKey,
            initValue: ctrl.res,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildItem(
                    title: '用户名',
                    child: SUTextField(
                      mapKey: 'userName',
                      hint: '请输入用户名',
                      validator: (text) => text.isNotBlank ? null : '请输入用户名',
                    ),
                  ),
                  _buildItem(
                    title: '密码',
                    child: SUTextField(
                      mapKey: 'passWord',
                      hint: '请输入密码',
                      isPassword: true,
                      validator: (text) => text.isNotBlank ? null : '请输入密码',
                    ),
                  ),
                  SMapKey(
                    mapKey: 'userInfo',
                    child: Column(
                      children: [
                        _buildItem(
                          title: '姓名',
                          child: SUTextField(
                            mapKey: 'name',
                            hint: '请输入姓名',
                            validator: (text) => text.isNotBlank ? null : '请输入姓名',
                          ),
                        ),
                        _buildItem(
                          title: '年龄',
                          child: SUTextField(
                            mapKey: 'passWord',
                            hint: '请输入年龄',
                            inputType: InputType.digit,
                            validator: (text) {
                              return (int.tryParse(text ?? '0') ?? 0) > 12 ? null : '年龄必须大于12';
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildItem(
                    title: '作品',
                    child: SUSpinner(
                      mapKey: 'article',
                      hint: '请选择作品',
                      source: ctrl.articles,
                      validator: (item) => null != item ? null : '请选择作品',
                    ),
                  ),
                  const SizedBox(height: 1000),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(height: 5),
          child,
        ],
      ),
    );
  }
}

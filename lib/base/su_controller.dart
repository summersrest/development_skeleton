import 'dart:async';
import 'package:development_skeleton/core/event_bus.dart';
import 'package:development_skeleton/development_skeleton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///# 页面Controller超类
///
///## 说明：页面Controller超类
abstract class SUController extends GetxController with HttpCanceler {
  ViewState viewState = ViewState.loading;
  StreamSubscription<EventMessage>? _subscription;
  final Map<String, ViewState> _viewStateTemp = {};
  ViewState _viewState = ViewState.loading;

  /// 消息接收函数
  late final ValueChanged<EventMessage>? _receiver = eventReceiver;

  /// 获取组件状态
  ViewState getViewState(String? id) => id == null ? _viewState : _viewStateTemp[id] ?? ViewState.loading;

  @override
  void onReady() async {
    super.onReady();
    _initEventSubscription();
    //网络请求
    await _requestApi();
  }

  ///# 监听消息
  _initEventSubscription() async {
    await _subscription?.cancel();
    if (null != _receiver) {
      _subscription = EventBus.instance.listen(_receiver);
    }
  }

  ///# 消息接收复写函数
  ///
  ///## 说明：
  ValueChanged<EventMessage>? get eventReceiver => null;

  ///# 网络请求
  ///
  ///## 说明：网络请求异常统一处理，只捕获网络请求异常。
  Future _requestApi() async {
    //网络请求
    try {
      await init();
    } on HttpHelperException catch (e) {
      //网络请求异常捕获处理
      showError(e.message);
    } catch (e) {
      //其他异常抛给框架处理
      rethrow;
    }
  }

  ///# 初始化
  ///
  ///## 说明：函数内进行初始化操作与网络请求，网络请求异常已统一捕获处理，若无特殊需求不需要手动捕获处理。
  init();

  ///# 页面显示加载状态
  ///
  /// 若需要指定组件，传入[id]参数
  void showLoading([String? id]) {
    _updateViewState(ViewState.loading, id);
  }

  ///# 显示页面内容
  ///
  /// 若需要指定组件，传入[id]参数
  void showContent([String? id]) {
    _updateViewState(ViewState.content, id);
  }

  ///# 显示空页面状态
  ///
  /// 若需要指定组件，传入[id]参数
  void showEmpty([String? id]) {
    _updateViewState(ViewState.empty, id);
  }

  ///# 显示异常页面状态
  ///
  /// 若需要指定组件，传入[id]参数
  void showError([String? id]) {
    _updateViewState(ViewState.error, id);
  }

  ///# 生成Http请求参数
  ///
  /// 生成Http请求参数的实例，省去手动添加[cancelToken]的麻烦。
  HttpParams httpParams({
    Map<String, dynamic>? param,
    Object? body,
    CancelToken? cancelToken,
    Options? options,
    String? savePath,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      HttpParams(
        param: param,
        body: body,
        cancelToken: cancelToken ?? getCancelToken(),
        options: options,
        savePath: savePath,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

  ///# 更新页面状态
  void _updateViewState(ViewState viewState, [String? id]) {
    if (null == id) {
      _viewState = viewState;
      update();
    } else  {
      if ((_viewStateTemp[id] ?? ViewState.loading) != viewState) {
        _viewStateTemp[id] = viewState;
        update([id]);
      }
    }
  }

  ///# 释放资源
  ///
  ///## 说明：释放资源
  @override
  void onClose() {
    super.onClose();
    _viewStateTemp.clear();
    _subscription?.cancel();
    //取消网络请求
    cancelByTag(runtimeType.toString());
  }
}

enum ViewState {
  loading,
  content,
  empty,
  error,
}

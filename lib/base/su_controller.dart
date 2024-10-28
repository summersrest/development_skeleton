import 'dart:async';
import 'package:development_skeleton/core/event_bus.dart';
import 'package:development_skeleton/http/http_canceler.dart';
import 'package:development_skeleton/http/http_helper_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

///# Get Controller超类
///
///## 说明：Get Controller超类
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
  ///
  ///@date：2024/10/18
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


  void showLoading([String? id]) {
    _updateViewState(ViewState.loading, id);
  }

  void showContent([String? id]) {
    _updateViewState(ViewState.content, id);
  }

  void showEmpty([String? id]) {
    _updateViewState(ViewState.empty, id);
  }

  void showError([String? id]) {
    _updateViewState(ViewState.error, id);
  }

  ///# 更新页面状态
  void _updateViewState(ViewState viewState, [String? id]) {
    if (null == id && _viewState != viewState) {
      _viewState = viewState;
      update();
    } else if (null != id) {
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

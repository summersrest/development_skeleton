import 'package:dio/dio.dart';

final Map<String, CancelToken> _cancelTokens = {};

///# 网络请求取消者
///
///## 说明：BaseController混入取消者，可以方便的取消网络请求
mixin HttpCanceler {
  ///# 获取CancelToken
  ///
  ///## 说明：不设置token，则默认当前类为token tag
  CancelToken getCancelToken([String? tag]) {
    tag ??= runtimeType.toString();
    CancelToken? cancelToken = _cancelTokens[tag];
    if (null != cancelToken && !cancelToken.isCancelled) {
      return cancelToken;
    } else {
      _cancelTokens.remove(tag);
      return _cancelTokens[tag] ??= CancelToken();
    }
  }

  ///# 取消网络请求
  ///
  ///## 说明：Controller中调用
  void cancelByTag(String? tag) {
    tag ??= runtimeType.toString();
    _cancelTokens[tag]?.cancel();
    _cancelTokens.remove(tag);
  }

  ///# 取消网络请求
  ///
  ///## 说明：Controller之外调用，在getCancel时，会移除已被取消的token
  static CancelToken? maybeOf(String tag) {
    return _cancelTokens[tag];
  }
}

import 'package:development_skeleton/utils/extension.dart';
import 'package:dio/dio.dart';

///# 网络请求异常
///
///## 说明：网络请求异常
class HttpHelperException {
  ///Dio异常
  final DioException exception;

  HttpHelperException(
    this.exception,
  );

  ///# 异常信息
  String get message {
    //DNS异常获取网络请求不可用时
    if (null == exception.response) {
      return exception.message ?? '网络请求不可用，请检查网络连接或稍后重试';
    }
    //网络请求取消
    if (exception.type == DioExceptionType.cancel) {
      return exception.message ?? '网络请求已取消';
    }
    //网络请求超时
    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout) {
      return exception.message ?? '请求超时';
    }
    //证书错误
    if (exception.type == DioExceptionType.badCertificate) {
      return exception.message ?? '证书错误';
    }
    //其他错误
    if (exception.message.isNotBlank) {
      return exception.message!;
    } else if (exception.error != null) {
      return exception.error.toString();
    } else {
      return exception.toString();
    }
  }

  ///# 异常状态码
  int? get statusCode {
    return exception.response?.statusCode;
  }
}

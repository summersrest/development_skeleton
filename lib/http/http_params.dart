import 'package:dio/dio.dart';

///# 网络请求参数
class HttpParams {
  final Map<String, dynamic>? param;
  final Object? body;
  final CancelToken? cancelToken;
  final Options? options;
  final String? savePath;
  final ProgressCallback? onSendProgress;
  final ProgressCallback? onReceiveProgress;

  HttpParams({
    this.param,
    this.body,
    this.cancelToken,
    this.options,
    this.savePath,
    this.onSendProgress,
    this.onReceiveProgress,
  });
}

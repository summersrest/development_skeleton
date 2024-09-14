import 'package:dio/dio.dart';
import 'package:development_skeleton/development_skeleton.dart';

class UnpackInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (JsonUtils.isMap(response.data)) {
      //返回数据解析
      Map<String, dynamic> map = JsonUtils.any2Map(response.data);
      if (map['error'] is int && map['error'] == 0) {
        response.data = map['data'];
        return handler.next(response);
      } else {
        return handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            error: DioExceptionType.unknown,
            message: map['message'],
          ),
        );
      }

    }
    return handler.reject(DioException(
      requestOptions: response.requestOptions,
      error: DioExceptionType.unknown,
      message: 'api返回数据结构异常',
    ));
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.cancel) return;
    return handler.next(err);
  }
}

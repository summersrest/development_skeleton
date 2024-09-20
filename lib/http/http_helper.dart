import 'package:development_skeleton/core/env_config.dart';
import 'package:development_skeleton/http/http_helper_exception.dart';
import 'package:development_skeleton/log/log.dart';
import 'package:development_skeleton/utils/json_utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:universal_io/io.dart';

///# 网络请求封装类
///
///## 说明：网络请求封装类
Map<String, HttpHelper> _httpHelpCache = {};

class HttpHelper {
  /// dio实例
  CommonDio? _dio;

  /// dio配置
  final BaseOptions options;

  /// 拦截器
  final List<Interceptor>? interceptors;

  /// 是否显示日志
  final bool isLog;

  /// 代理
  final String? proxy;

  HttpHelper({
    required this.options,
    this.interceptors,
    this.isLog = true,
    this.proxy,
  }) {
    options.responseType = ResponseType.plain;
    _dio ??= CommonDio(options: options, isLog: isLog, proxy: proxy);
    if (null != interceptors && interceptors!.isNotEmpty) {
      _dio!.interceptors.addAll(interceptors!);
    }
  }

  ///# 实例化HttpHelper
  ///
  ///## 说明：实例化HttpHelper
  factory HttpHelper.from(HttpConfig httpConfig) {
    HttpHelper helper = HttpHelper(
      options: BaseOptions(
        baseUrl: httpConfig.baseUrl,
        connectTimeout: Duration(milliseconds: httpConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: httpConfig.receiveTimeout),
      ),
      interceptors: httpConfig.interceptors,
      isLog: httpConfig.enableLog,
      proxy: httpConfig.proxy,
    );
    _httpHelpCache[httpConfig.name] = helper;
    return helper;
  }

  ///# 根据名称获取HttpHelper实例
  ///
  ///## 说明：根据名称获取HttpHelper实例
  static HttpHelper of(String name) {
    HttpHelper? httpHelper = _httpHelpCache[name];
    if (null == httpHelper) {
      throw Exception('HttpHelper not found');
    }
    return httpHelper;
  }

  ///# Post请求
  ///
  ///## 说明：Post请求
  Future<T?> post<T>({
    required String url,
    Map<String, dynamic>? param,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(Map<String, dynamic> map)? onMap,
    T Function(List<Map<String, dynamic>> list)? onList,
  }) async {
    try {
      final Response response = await _dio!.post(
        url,
        data: body,
        queryParameters: param,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      if (JsonUtils.isMap(response.data) && null != onMap) {
        return onMap(JsonUtils.any2Map(response.data));
      } else if (JsonUtils.isList(response.data) && null != onList) {
        return onList(JsonUtils.anyToList(response.data));
      }
      return JsonUtils.anyToType<T>(response.data);
    } on DioException catch (e) {
      _handlerError(e);
      return null;
    } catch (e) {
      rethrow;
    }
  }

  ///# Get请求
  ///
  ///## 说明：Get请求
  Future<T?> get<T>({
    required String url,
    Map<String, dynamic>? param,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    T Function(Map<String, dynamic> map)? onMap,
    T Function(List<dynamic> list)? onList,
  }) async {
    try {
      final Response response = await _dio!.get(
        url,
        data: body,
        queryParameters: param,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      if (JsonUtils.isMap(response.data) && null != onMap) {
        return onMap(JsonUtils.any2Map(response.data));
      } else if (JsonUtils.isList(response.data) && null != onList) {
        return onList(JsonUtils.anyToList(response.data));
      }
      return JsonUtils.anyToType<T>(response.data);
    } on DioException catch (e) {
      _handlerError(e);
      return null;
    } catch (e) {
      rethrow;
    }
  }

  ///# 下载文件
  ///
  ///## 说明：下载文件
  Future download({
    required String url,
    required String savePath,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await Dio(options).download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handlerError(e);
      return null;
    } catch (e) {
      rethrow;
    }
  }

  ///# 统一处理错误
  Future _handlerError(DioException e) async {
    //关闭进度条
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    throw HttpHelperException(e);
  }
}

///# Http对象封装
///
///## 说明：添加代理，返回数据进行Decode与日志打印。
class CommonDio extends DioMixin implements Dio {
  CommonDio({
    required BaseOptions options,
    String? proxy,
    required bool isLog,
  }) : super() {
    this.options = options;

    assert(() {
      if (isLog) {
        // インターセプターにdio印刷ログを追加する。
        interceptors.add(LogInterceptor(
          request: false,
          requestHeader: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (Object object) {
            Log.simpleI(object);
          },
        ));
      }
      return true;
    }());
    //　代理
    if (!kIsWeb && (proxy?.isNotEmpty ?? false)) {
      httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.findProxy = (uri) {
            return 'PROXY $proxy';
          };
          return client;
        },
      );
    } else {
      httpClientAdapter = HttpClientAdapter();
    }
  }
}

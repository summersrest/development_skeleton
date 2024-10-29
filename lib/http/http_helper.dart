import 'package:development_skeleton/core/env_config.dart';
import 'package:development_skeleton/http/http_helper_exception.dart';
import 'package:development_skeleton/log/log.dart';
import 'package:development_skeleton/utils/json_utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:universal_io/io.dart';

import 'http_params.dart';

///# 网络请求实例
///
///## 说明：网络请求实例
Map<String, HttpHelper> _httpHelpCache = {};

class HttpHelper {
  /// dio实例
  Dio? _dio;

  /// dio配置
  final BaseOptions options;

  /// 日志打印拦截器
  final Interceptor? logInterceptor;

  /// 是否显示日志
  final bool isLog;

  HttpHelper({
    required this.options,
    List<Interceptor>? interceptors,
    this.logInterceptor,
    this.isLog = true,
    String? proxy,
  }) {
    options.responseType = ResponseType.plain;
    _dio ??= Dio(options);
    // 设置代理
    if (!kIsWeb && (proxy?.isNotEmpty ?? false)) {
      _dio?.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.findProxy = (uri) {
            return 'PROXY $proxy';
          };
          return client;
        },
      );
    }
    // 拦截器
    if (null != interceptors && interceptors.isNotEmpty) {
      _dio!.interceptors.addAll(interceptors);
      assert(() {
        if (isLog) {
          _dio!.interceptors.add(logInterceptor ??
              LogInterceptor(
                request: false,
                requestHeader: false,
                requestBody: true,
                responseHeader: false,
                responseBody: true,
                error: true,
                logPrint: (Object object) {
                  Log.longText(object, tag: 'HttpRequest');
                },
              ));
        }
        return true;
      }());
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
      logInterceptor: httpConfig.logInterceptor,
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

  ///# 获取拦截器
  ///
  ///## 说明：获取拦截器
  Interceptors get interceptors => _dio!.interceptors;

  ///# Post请求
  ///
  ///## 说明：Post请求
  Future<T?> post<T>({
    required String url,
    required HttpParams httpParams,
    T Function(Map<String, dynamic> map)? onMap,
    T Function(List<Map<String, dynamic>> list)? onList,
  }) async {
    try {
      final Response response = await _dio!.post(
        url,
        data: httpParams.body,
        queryParameters: httpParams.param,
        options: httpParams.options,
        cancelToken: httpParams.cancelToken,
        onSendProgress: httpParams.onSendProgress,
        onReceiveProgress: httpParams.onReceiveProgress,
      );
      if (JsonUtils.isMap(response.data) && null != onMap) {
        return onMap(JsonUtils.anyToMap(response.data));
      } else if (JsonUtils.isList(response.data) && null != onList) {
        return onList(JsonUtils.anyToList(response.data));
      }
      return JsonUtils.anyToType<T>(response.data);
    } on DioException catch (e) {
      await _handlerError(e);
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
    required HttpParams httpParams,
    T Function(Map<String, dynamic> map)? onMap,
    T Function(List<dynamic> list)? onList,
  }) async {
    try {
      final Response response = await _dio!.get(
        url,
        data: httpParams.body,
        queryParameters: httpParams.param,
        options: httpParams.options,
        cancelToken: httpParams.cancelToken,
        onReceiveProgress: httpParams.onReceiveProgress,
      );
      if (JsonUtils.isMap(response.data) && null != onMap) {
        return onMap(JsonUtils.anyToMap(response.data));
      } else if (JsonUtils.isList(response.data) && null != onList) {
        return onList(JsonUtils.anyToList(response.data));
      }
      return JsonUtils.anyToType<T>(response.data);
    } on DioException catch (e) {
      await _handlerError(e);
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
      final Response response = await _dio!.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      await _handlerError(e);
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

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/routes/app_routers_import.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/validate_mobile_screen.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../extension/context_extension.dart';
import '../utils/common_methods.dart';

// -------------------- ENUM --------------------
enum ResponseState {
  sleep,
  offline,
  loading,
  pagination,
  complete,
  error,
  unauthorized,
  badRequest
}

class ApiResponse {
  ResponseState state;
  dynamic data;

  ApiResponse({
    required this.state,
    required this.data,
  });
}

// -------------------- API HELPER --------------------
class ApiHelper {
  static ApiHelper? _instance;

  ApiHelper._();

  static ApiHelper get instance {
    _instance ??= ApiHelper._();
    return _instance!;
  }

  MediaType appMediaType(String filePath) {
    var list = "${lookupMimeType(filePath)}".split('/');
    return MediaType(
      list.firstOrNull ?? 'application',
      list.lastOrNull ?? 'octet-stream',
    );
  }

  // -------------------- DIO SETUP --------------------
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 7),
      receiveTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),
    ),
  )
    ..interceptors.add(ConnectionInterceptor())
    ..interceptors.addAll(
      kDebugMode
          ? [
              PrettyDioLogger(
                request: true,
                requestHeader: true,
                requestBody: true,
                responseBody: true,
                responseHeader: false,
                compact: false,
              ),
            ]
          : [],
    );

  // -------------------- COMMON OPTIONS --------------------
  Options _options(Map<String, String>? headers, bool hasToken) {
    return Options(
      contentType: 'application/json',
      followRedirects: true,
      validateStatus: (_) => true,
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Accept-Language': HiveMethods.getLang(),
        if (HiveMethods.getToken() != null && hasToken)
          'Authorization': "Bearer ${HiveMethods.getToken()}",
        ...?headers,
      },
    );
  }

  Map<String, String> _offlineMessage() {
    return {
      'message': AppRouters.navigatorKey.currentContext!.apiTr(
        ar: "تأكد من الاتصال بالإنترنت",
        en: "Make sure you are connected to the internet",
      ),
    };
  }

  Map<String, String> _errorMessage() {
    return {
      'message': AppRouters.navigatorKey.currentContext!.apiTr(
        ar: "حدث خطأ",
        en: "An error occurred",
      ),
    };
  }

  // -------------------- GET --------------------
  Future<ApiResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    void Function()? onFinish,
    void Function(int, int)? onReceiveProgress,
    bool hasToken = true,
  }) async {
    return _sendRequest(
      type: "GET",
      url: url,
      queryParameters: queryParameters,
      headers: headers,
      onFinish: onFinish,
      hasToken: hasToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // -------------------- POST --------------------
  Future<ApiResponse> post(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, String>? headers,
    void Function()? onFinish,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    bool hasToken = true,
    bool isMultipart = false,
  }) async {
    ApiResponse responseJson;

    if (await CommonMethods.hasConnection() == false) {
      responseJson = ApiResponse(
        state: ResponseState.offline,
        data: _offlineMessage(),
      );
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }

    try {
      final dataToSend = isMultipart ? FormData.fromMap(body) : body;

      final response = await _dio.post(
        url,
        queryParameters: queryParameters,
        data: dataToSend,
        options: _options(headers, hasToken),
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

      responseJson = _buildResponse(response);
      Future.delayed(Duration.zero, onFinish);
    } on DioException {
      responseJson = ApiResponse(
        state: ResponseState.error,
        data: _errorMessage(),
      );
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    } on SocketException {
      responseJson = ApiResponse(
        state: ResponseState.offline,
        data: _offlineMessage(),
      );
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }

    return responseJson;
  }

  // -------------------- PUT --------------------
  Future<ApiResponse> put(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, String>? headers,
    void Function()? onFinish,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    bool hasToken = true,
  }) async {
    return _sendRequest(
      type: "PUT",
      url: url,
      queryParameters: queryParameters,
      body: body,
      headers: headers,
      onFinish: onFinish,
      hasToken: hasToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );
  }

  // -------------------- PATCH --------------------
  Future<ApiResponse> patch(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, String>? headers,
    void Function()? onFinish,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    bool hasToken = true,
  }) async {
    return _sendRequest(
      type: "PATCH",
      url: url,
      queryParameters: queryParameters,
      body: body,
      headers: headers,
      onFinish: onFinish,
      hasToken: hasToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );
  }

  // -------------------- DELETE --------------------
  Future<ApiResponse> delete(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, String>? headers,
    void Function()? onFinish,
    bool hasToken = true,
  }) async {
    return _sendRequest(
      type: "DELETE",
      url: url,
      queryParameters: queryParameters,
      body: body,
      headers: headers,
      onFinish: onFinish,
      hasToken: hasToken,
    );
  }

  // -------------------- DOWNLOAD --------------------
  Future<ApiResponse> download(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    void Function()? onFinish,
    void Function(int, int)? onReceiveProgress,
    bool hasToken = true,
  }) async {
    if (!await CommonMethods.hasConnection()) {
      return ApiResponse(
        state: ResponseState.offline,
        data: _offlineMessage(),
      );
    }

    final fileName = path.basename(url);
    final savePath = await _getFilePath(fileName);

    try {
      final response = await _dio.download(
        url,
        savePath,
        queryParameters: queryParameters,
        options: _options(headers, hasToken),
        onReceiveProgress: onReceiveProgress,
      );

      Future.delayed(Duration.zero, onFinish);
      return _buildResponse(response);
    } catch (_) {
      Future.delayed(Duration.zero, onFinish);
      return ApiResponse(state: ResponseState.error, data: _errorMessage());
    }
  }

  // -------------------- SHARED REQUEST HANDLER --------------------
  Future<ApiResponse> _sendRequest({
    required String type,
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, String>? headers,
    void Function()? onFinish,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    required bool hasToken,
  }) async {
    if (!await CommonMethods.hasConnection()) {
      return ApiResponse(state: ResponseState.offline, data: _offlineMessage());
    }

    try {
      late Response response;

      switch (type) {
        case "GET":
          response = await _dio.get(
            url,
            queryParameters: queryParameters,
            options: _options(headers, hasToken),
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case "POST":
          response = await _dio.post(
            url,
            queryParameters: queryParameters,
            data: body,
            options: _options(headers, hasToken),
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
          );
          break;
        case "PUT":
          response = await _dio.put(
            url,
            queryParameters: queryParameters,
            data: body,
            options: _options(headers, hasToken),
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
          );
          break;
        case "PATCH":
          response = await _dio.patch(
            url,
            queryParameters: queryParameters,
            data: body,
            options: _options(headers, hasToken),
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
          );
          break;
        case "DELETE":
          response = await _dio.delete(
            url,
            queryParameters: queryParameters,
            data: body,
            options: _options(headers, hasToken),
          );
          break;
      }

      Future.delayed(Duration.zero, onFinish);
      return _buildResponse(response);
    } catch (_) {
      Future.delayed(Duration.zero, onFinish);
      return ApiResponse(state: ResponseState.error, data: _errorMessage());
    }
  }

  // -------------------- RESPONSE BUILDER --------------------
  ApiResponse _buildResponse(Response response) {
    final data = response.data;

    switch (response.statusCode) {
      case 200:
      case 201:
        return ApiResponse(state: ResponseState.complete, data: data);

      case 401:
        Future.delayed(Duration.zero, () {
          HiveMethods.deleteToken();
          if (!HiveMethods.isVisitor()) {
            NavigatorMethods.pushNamedAndRemoveUntil(
              AppRouters.navigatorKey.currentContext!,
              ValidateMobileScreen.routeName,
            );
          }
        });
        return ApiResponse(state: ResponseState.unauthorized, data: data);

      case 400:
      case 422:
      case 403:
        return ApiResponse(state: ResponseState.error, data: data);

      case 404:
        return ApiResponse(state: ResponseState.badRequest, data: data);

      default:
        return ApiResponse(state: ResponseState.error, data: data);
    }
  }

  // -------------------- SAVE PATH --------------------
  Future<String> _getFilePath(String fileName) async {
    Directory dir = await path_provider.getApplicationDocumentsDirectory();
    return '${dir.path}/$fileName.pdf';
  }
}

// -------------------- CONNECTION INTERCEPTOR --------------------
class ConnectionInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final hasConnection = await CommonMethods.hasConnectionFast();

    if (!hasConnection) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: "No internet connection",
          type: DioExceptionType.connectionError,
        ),
      );
    }

    handler.next(options);
  }
}

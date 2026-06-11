import 'package:dio/dio.dart';

class ApiClientException implements Exception {
  ApiClientException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(String baseUrl)
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 12),
          receiveTimeout: const Duration(seconds: 20),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Future<dynamic> getJson(String path) async {
    try {
      return (await _dio.get<dynamic>(path)).data;
    } on DioException catch (error) {
      throw _toException(error);
    }
  }

  Future<dynamic> postJson(String path, Map<String, dynamic> body) async {
    try {
      return (await _dio.post<dynamic>(path, data: body)).data;
    } on DioException catch (error) {
      throw _toException(error);
    }
  }

  Future<dynamic> patchJson(String path, Map<String, dynamic> body) async {
    try {
      return (await _dio.patch<dynamic>(path, data: body)).data;
    } on DioException catch (error) {
      throw _toException(error);
    }
  }

  ApiClientException _toException(DioException error) {
    final data = error.response?.data;
    final statusCode = error.response?.statusCode;
    var message = 'Falha de comunicacao com a API.';

    if (data is String && data.trim().isNotEmpty) {
      message = data;
    } else if (data is Map && data['message'] != null) {
      message = data['message'].toString();
    } else if (error.message != null && error.message!.isNotEmpty) {
      message = error.message!;
    }

    return ApiClientException(message, statusCode: statusCode);
  }

  void close() => _dio.close();
}
import 'package:dio/dio.dart';

/// Custom exception for API errors.
class ApiException implements Exception {
  final String message;
  final DioException? dioException;
  final String? userMessage;

  ApiException(this.message, [this.dioException, this.userMessage]);

  String get displayMessage => userMessage ?? message;

  @override
  String toString() => 'ApiException: $message';
}

/// Centralized API client using Dio.
class ApiClient {
  static const String _baseUrl = 'https://alto.samyn.ovh';
  static ApiClient? _instance;
  late final Dio _dio;

  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Request interceptor for logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQ [${options.method}] ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESP [${response.statusCode}] ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('ERR [${error.response?.statusCode}] ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  static String _getUserMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout de connexion';
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        switch (code) {
          case 400:
            return 'Mauvaise requête';
          case 401:
            return 'Non autorisé';
          case 403:
            return 'Interdit';
          case 404:
            return 'Non trouvé';
          case 500:
            return 'Erreur serveur';
          default:
            return 'Erreur serveur ($code)';
        }
      case DioExceptionType.cancel:
        return 'Opération annulée';
      case DioExceptionType.badCertificate:
        return 'Certificat invalide';
      case DioExceptionType.connectionError:
        return 'Erreur de connexion';
      default:
        return 'Erreur réseau inconnue';
    }
  }

  /// Singleton instance
  static ApiClient get instance => _instance ??= ApiClient._();

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ApiException('GET $path failed', e, _getUserMessage(e));
    }
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw ApiException('POST $path failed', e, _getUserMessage(e));
    }
  }

  Future<Response> put(String path, Map<String, dynamic> data) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw ApiException('PUT $path failed', e, _getUserMessage(e));
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ApiException('DELETE $path failed', e, _getUserMessage(e));
    }
  }
}

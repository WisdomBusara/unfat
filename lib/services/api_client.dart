import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'token_storage.dart';

/// Thin wrapper around Dio: attaches the access token to every request and
/// transparently refreshes it once on a 401 before retrying, so callers
/// never have to think about token expiry.
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;
  bool _isRefreshing = false;

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage.accessToken;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final isUnauthorized = error.response?.statusCode == 401;
        final isAuthRoute = error.requestOptions.path.startsWith('/auth/');

        if (isUnauthorized && !isAuthRoute && !_isRefreshing) {
          _isRefreshing = true;
          try {
            final refreshed = await _refreshAccessToken();
            _isRefreshing = false;

            if (refreshed) {
              final token = await TokenStorage.accessToken;
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await dio.fetch(error.requestOptions);
              return handler.resolve(response);
            }
          } catch (_) {
            _isRefreshing = false;
          }
          await TokenStorage.clear();
        }

        handler.next(error);
      },
    ));
  }

  Future<bool> _refreshAccessToken() async {
    final refreshToken = await TokenStorage.refreshToken;
    if (refreshToken == null) return false;

    try {
      final response = await Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)).post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final userId = await TokenStorage.userId ?? '';
      await TokenStorage.saveTokens(
        accessToken: response.data['accessToken'] as String,
        refreshToken: response.data['refreshToken'] as String,
        userId: userId,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  factory ApiException.fromDioError(DioException e) {
    final data = e.response?.data;
    final message = (data is Map && data['error'] != null)
        ? data['error'] as String
        : e.message ?? 'Network error';
    return ApiException(e.response?.statusCode, message);
  }

  @override
  String toString() => message;
}

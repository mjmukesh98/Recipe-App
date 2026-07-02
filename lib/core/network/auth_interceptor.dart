import 'package:dio/dio.dart';

import '../services/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorageService.getToken();
    print("TOKEN SENT 👉 $token");
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await SecureStorageService.getRefreshToken();

        if (refreshToken == null) {
          return _logout(handler, err);
        }

        final response = await dio.post(
          "/auth/refresh",
          data: {"refreshToken": refreshToken},
        );

        final newToken = response.data["accessToken"];

        await SecureStorageService.saveToken(newToken);
        err.requestOptions.headers["Authorization"] = "Bearer $newToken";

        final retry = await dio.fetch(err.requestOptions);

        return handler.resolve(retry);
      } on DioException catch (e) {
        // refresh failed

        await SecureStorageService.clearAll();

        return _logout(handler, e);
      }
    }

    handler.next(err);
  }

  Future<void> _logout(
    ErrorInterceptorHandler handler,
    DioException error,
  ) async {
    await SecureStorageService.clearAll();

    // pass error to Bloc/UI
    return handler.reject(
      DioException(
        requestOptions: error.requestOptions,
        error: "Session expired. Please login again",
        type: DioExceptionType.cancel,
      ),
    );
  }
}

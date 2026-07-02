import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'auth_interceptor.dart';


class DioClient {

  final Dio dio;


  DioClient()
      : dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,

      connectTimeout:
      const Duration(seconds: 30),

      receiveTimeout:
      const Duration(seconds: 30),

      headers: {
        "Content-Type": "application/json",
      },
    ),
  ) {

    dio.interceptors.add(
      AuthInterceptor(dio),
    );


    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

  }
}
import 'package:demo/core/utils/AppLogger.dart';
import 'package:dio/dio.dart';

import 'dio_client.dart';

class ApiClient {
  final DioClient dioClient;

  ApiClient(this.dioClient);

  Future<dynamic> get({required String path}) async {
    AppLogger.request(path, method: 'GET');
    final response = await dioClient.dio.get(path);
    AppLogger.response(path, response.statusCode ?? 200, response.data);
    return response;
  }

  Future<dynamic> post({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    AppLogger.request(path, method: 'POST', body: data);
    final response = await dioClient.dio.post(path, data: data);
    AppLogger.response(path, response.statusCode ?? 200, response.data);
    return response;
  }

  Future<dynamic> put({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    AppLogger.request(path, method: 'PUT', body: data);
    final response = await dioClient.dio.put(path, data: data);
    AppLogger.response(path, response.statusCode ?? 200, response.data);
    return response;
  }

  Future<Response> delete(String path) async {
    AppLogger.request(path, method: 'DELETE');
    final response = await dioClient.dio.delete(path);
    AppLogger.response(path, response.statusCode ?? 200, response.data);
    return response;
  }
}

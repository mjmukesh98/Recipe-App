import 'package:demo/core/network/api_client.dart';
import 'package:demo/core/network/api_endpoints.dart';
import 'package:demo/features/auth/data/models/LoginModel.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<LoginModel> login(String username, String password) async {
    final response = await apiClient.post(
      path: ApiEndpoints.login,
      data: {"username": username, "password": password},
    );

    return LoginModel.fromMap(response.data);
  }
}

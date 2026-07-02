import 'package:demo/features/auth/data/models/LoginModel.dart';

abstract class AuthRepository {
  Future<LoginModel> login(String username, String password);
}
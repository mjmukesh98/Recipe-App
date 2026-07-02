import 'package:demo/features/auth/data/models/LoginModel.dart';
import 'package:demo/features/auth/data/repository/AuthRepository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LoginModel> call(String username, String password) {
    return repository.login(username, password);
  }
}

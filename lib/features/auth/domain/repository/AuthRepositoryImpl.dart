import 'package:demo/core/constants/app_constants.dart';
import 'package:demo/core/services/app_prefernces.dart';
import 'package:demo/core/services/secure_storage_service.dart';
import 'package:demo/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:demo/features/auth/data/models/LoginModel.dart';
import 'package:demo/features/auth/data/repository/AuthRepository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<LoginModel> login(String username, String password) async {
    final user = await remote.login(username, password);
    await SecureStorageService.saveToken(user.accessToken ?? "");
    final firstName = user.firstName?.trim() ?? "";
    final lastName = user.lastName?.trim() ?? "";

    final fullName = "$firstName $lastName".trim();

    if (fullName.isNotEmpty) {
      await AppPreference.set(AppStrings.fullName, fullName);
    }
    return user;
  }
}

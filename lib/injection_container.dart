import 'package:demo/core/network/api_client.dart';
import 'package:demo/core/network/dio_client.dart';
import 'package:demo/core/services/network_service.dart';
import 'package:demo/core/services/secure_storage_service.dart';
import 'package:demo/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:demo/features/auth/data/repository/AuthRepository.dart';
import 'package:demo/features/auth/domain/repository/AuthRepositoryImpl.dart';
import 'package:demo/features/auth/domain/usecases/login_usecase.dart';
import 'package:demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demo/features/recipes/data/datasource/recipes_remote_datasource.dart';
import 'package:demo/features/recipes/data/repository/RecipesRepository.dart';
import 'package:demo/features/recipes/domain/repository/RecipsRepositoryImpl.dart';
import 'package:demo/features/recipes/domain/usecases/recipes_usecase.dart';
import 'package:demo/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void init() {
  // ===========================
  // CORE
  // ===========================

  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => ApiClient(sl()));

  sl.registerLazySingleton(() => SecureStorageService());

  // ===========================
  // AUTH MODULE
  // ===========================

  // DataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // UseCase
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Bloc
  sl.registerFactory(() => AuthBloc(sl()));

  // ===========================
  // RECIPE MODULE
  // ===========================

// ===========================
// RECIPE MODULE
// ===========================

// DataSource
  sl.registerLazySingleton<RecipesRemoteDataSource>(
        () => RecipesRemoteDataSource(sl(),sl()),
  );
  sl.registerLazySingleton<NetworkService>(
        () => NetworkService(),
  );
// Repository
  sl.registerLazySingleton<RecipesRepository>(
        () => RecipesRepositoryImpl(sl()),
  );

// UseCase
  sl.registerLazySingleton(
        () => RecipesUseCase(sl()),
  );

// Bloc
  sl.registerFactory(
        () => RecipeBloc(sl()),
  );
}

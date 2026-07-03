import 'package:demo/core/error/error_handler.dart';
import 'package:demo/core/network/api_client.dart';
import 'package:demo/core/network/api_endpoints.dart';
import 'package:demo/core/services/hive_service.dart';
import 'package:demo/core/services/network_service.dart';
import 'package:demo/features/recipes/data/models/RecipesHiveModel.dart';
import 'package:demo/features/recipes/data/models/RecipesModel.dart';
import 'package:dio/dio.dart';

class RecipesRemoteDataSource {
  final ApiClient apiClient;
  final NetworkService networkService;

  RecipesRemoteDataSource(this.apiClient, this.networkService);

  Future<RecipesModel> recipes() async {
    final isConnected = await networkService.checkConnection();

    if (!isConnected) {
      throw Exception("No internet connection. Please check your network.");
    }

    try {
      final response = await apiClient.get(path: ApiEndpoints.recipes);
      final model = RecipesModel.fromMap(response.data);

      await HiveService.recipesBox.clear();

      await HiveService.recipesBox.putAll({
        for (var r in model.recipes ?? [])
          r.id!: RecipeHiveModel.fromMap(r.toMap()),
      });

      return model;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Recipe> recipesId({int? id}) async {
    final isConnected = await networkService.checkConnection();

    if (!isConnected) {
      throw Exception("No internet connection. Please check your network.");
    }

    try {
      final response = await apiClient.get(path: "${ApiEndpoints.recipes}/$id");
      return Recipe.fromMap(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}

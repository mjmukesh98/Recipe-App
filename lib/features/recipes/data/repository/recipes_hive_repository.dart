import 'package:demo/core/services/hive_service.dart';
import 'package:demo/features/recipes/data/models/RecipesHiveModel.dart';
import 'package:hive/hive.dart';

class RecipesHiveRepository {
  Box<RecipeHiveModel> get box => HiveService.recipesBox;

  List<RecipeHiveModel> getAll() {
    return box.values.toList();
  }

  Future<void> addRecipe(RecipeHiveModel recipe) async {
    await box.put(recipe.id, recipe);
  }

  Future<void> updateRecipe(RecipeHiveModel recipe) async {
    await box.put(recipe.id, recipe);
  }

  Future<void> deleteRecipe(int id) async {
    await box.delete(id);
  }
  RecipeHiveModel? getById(int id) {
    return box.get(id);
  }
  Future<void> addAll(List<RecipeHiveModel> recipes) async {
    await box.clear();
    await box.putAll({for (var r in recipes) r.id: r});
  }
}

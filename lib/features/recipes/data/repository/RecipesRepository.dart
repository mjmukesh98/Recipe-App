import 'package:demo/features/recipes/data/models/RecipesModel.dart';

abstract class RecipesRepository {
  Future<RecipesModel> recipes();

  Future<Recipe> recipesId({int? id});
}

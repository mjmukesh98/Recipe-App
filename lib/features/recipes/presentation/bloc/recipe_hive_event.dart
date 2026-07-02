import 'package:demo/features/recipes/data/models/RecipesHiveModel.dart';

abstract class RecipeHiveEvent {}

class LoadHiveRecipes extends RecipeHiveEvent {}

class AddHiveRecipe extends RecipeHiveEvent {
  final RecipeHiveModel recipe;

  AddHiveRecipe(this.recipe);
}

class DeleteHiveRecipe extends RecipeHiveEvent {
  final int id;

  DeleteHiveRecipe(this.id);
}

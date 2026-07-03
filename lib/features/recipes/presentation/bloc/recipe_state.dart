import 'package:demo/features/recipes/data/models/RecipesModel.dart';

abstract class RecipesState {}

class RecipesInitial extends RecipesState {}

class RecipesLoading extends RecipesState {}

class RecipesSuccess extends RecipesState {
  final RecipesModel recipes;
  final List<Recipe> filteredRecipes;
  final List<Recipe> showRecipesList;
  final Recipe? recipeDetail;

  RecipesSuccess(
    this.recipes,
    this.filteredRecipes,
    this.showRecipesList, {
    this.recipeDetail,
  });

  RecipesSuccess copyWith({
    RecipesModel? recipes,
    List<Recipe>? filteredRecipes,
    List<Recipe>? showRecipesList,
    Recipe? recipeDetail,
  }) {
    return RecipesSuccess(
      recipes ?? this.recipes,
      filteredRecipes ?? this.filteredRecipes,
      showRecipesList ?? this.showRecipesList,
      recipeDetail: recipeDetail ?? this.recipeDetail,
    );
  }
}

class RecipesFailure extends RecipesState {
  final String message;

  RecipesFailure(this.message);
}

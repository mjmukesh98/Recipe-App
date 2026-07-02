import 'package:demo/features/recipes/data/models/RecipesModel.dart';

abstract class RecipesState {}

class RecipesInitial extends RecipesState {}

class RecipesLoading extends RecipesState {}

class RecipesSuccess extends RecipesState {
  final RecipesModel recipes;
  final List<Recipe> filteredRecipes;
  final List<Recipe> showRecipesList;

  RecipesSuccess(this.recipes, this.filteredRecipes, this.showRecipesList);

  RecipesSuccess copyWith({
    List<Recipe>? filteredRecipes,
    List<Recipe>? showRecipesList,
  }) {
    return RecipesSuccess(
      recipes,
      filteredRecipes ?? this.filteredRecipes,
      this.showRecipesList,
    );
  }
}

class RecipesFailure extends RecipesState {
  final String message;

  RecipesFailure(this.message);
}

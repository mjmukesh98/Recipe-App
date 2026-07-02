abstract class RecipesEvent {}

class GetRecipe extends RecipesEvent {}

class SearchRecipe extends RecipesEvent {
  final String query;

  SearchRecipe(this.query);
}

class RefreshRecipe extends RecipesEvent {}

class LoadLocalRecipe extends RecipesEvent {}

class ThemeChange extends RecipesEvent {}

class SortRecipe extends RecipesEvent {
  final String type;

  SortRecipe(this.type);
}

class FilterRecipe extends RecipesEvent {
  final String cuisine; // 👈 add this

  FilterRecipe(this.cuisine);
}

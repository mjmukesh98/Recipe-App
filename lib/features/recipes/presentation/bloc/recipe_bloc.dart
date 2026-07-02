import 'package:demo/core/services/hive_service.dart';
import 'package:demo/core/services/network_service.dart';
import 'package:demo/features/recipes/data/models/RecipesModel.dart';
import 'package:demo/features/recipes/domain/usecases/recipes_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipesEvent, RecipesState> {
  final RecipesUseCase recipeUseCase;
  List<Recipe> _allRecipes = [];
  List<Recipe> _allShowRecipes = [];

  RecipeBloc(this.recipeUseCase) : super(RecipesInitial()) {
    on<GetRecipe>(_onRecipe);
    on<RefreshRecipe>(_onRefreshRecipe);
    on<SearchRecipe>(_onSearchRecipe);
    on<FilterRecipe>(_onFilterRecipe);
    on<SortRecipe>(_onSortRecipe);
    on<LoadLocalRecipe>(_onLoadLocalRecipe);
  }

  Future<void> _onRecipe(GetRecipe event, Emitter<RecipesState> emit) async {
    emit(RecipesLoading());
    final isConnected = await NetworkService().checkConnection();
    if (!isConnected) {
      throw Exception("No internet connection. Please check your network.");
    }
    try {
      final recipe = await recipeUseCase.recipes();
      _allRecipes = recipe.recipes ?? [];
      _allShowRecipes = recipe.recipes ?? [];
      emit(RecipesSuccess(recipe, _allRecipes, _allShowRecipes));
    } catch (e) {
      emit(RecipesFailure(e.toString()));
    }
  }

  Future<void> _onRefreshRecipe(
    RefreshRecipe event,
    Emitter<RecipesState> emit,
  ) async {
    try {
      final recipe = await recipeUseCase.recipes();
      _allRecipes = recipe.recipes ?? [];
      _allShowRecipes = recipe.recipes ?? [];

      emit(RecipesSuccess(recipe, _allRecipes, _allShowRecipes));
    } catch (e) {
      emit(RecipesFailure(e.toString()));
      return; // Explicitly tells the compiler the function execution is done here
    }
  }

  Future<void> _onLoadLocalRecipe(
    LoadLocalRecipe event,
    Emitter<RecipesState> emit,
  ) async {
    try {
      final localRecipes = HiveService.recipesBox.values.map((e) {
        return Recipe(
          id: e.id,
          name: e.name,
          ingredients: e.ingredients,
          instructions: e.instructions,
          prepTimeMinutes: e.prepTimeMinutes,
          cookTimeMinutes: e.cookTimeMinutes,
          servings: e.servings,
          difficulty: e.difficulty,
          cuisine: e.cuisine,
          caloriesPerServing: e.caloriesPerServing,
          tags: e.tags,
          userId: e.userId,
          image: e.image,
          rating: e.rating,
          reviewCount: e.reviewCount,
          mealType: e.mealType,
          isFavorite: e.isFavorite,
        );
      }).toList();

      _allRecipes = localRecipes;
      _allShowRecipes = localRecipes;
      emit(RecipesSuccess(RecipesModel(), _allRecipes, _allShowRecipes));
    } catch (e) {
      emit(RecipesFailure(e.toString()));
      return; // Explicitly tells the compiler the function execution is done here
    }
  }

  void _onSearchRecipe(SearchRecipe event, Emitter<RecipesState> emit) {
    final query = event.query.toLowerCase();

    final filtered = _allRecipes.where((recipe) {
      final name = recipe.name?.toLowerCase() ?? "";
      final cuisine = recipe.cuisine?.toLowerCase() ?? "";
      final tags = (recipe.tags ?? []).join(" ").toLowerCase();

      return name.contains(query) ||
          cuisine.contains(query) ||
          tags.contains(query);
    }).toList();

    final currentState = state;

    if (currentState is RecipesSuccess) {
      emit(RecipesSuccess(currentState.recipes, filtered, filtered));
    }
  }

  void _onFilterRecipe(FilterRecipe event, Emitter<RecipesState> emit) {
    if (state is! RecipesSuccess) return;

    final current = state as RecipesSuccess;

    if (event.cuisine == null || event.cuisine!.isEmpty) {
      emit(current.copyWith(filteredRecipes: _allRecipes));
      return;
    }

    final filtered = _allRecipes.where((recipe) {
      final cuisine = recipe.cuisine?.toLowerCase() ?? "";
      return cuisine.contains(event.cuisine!.toLowerCase());
    }).toList();

    emit(current.copyWith(filteredRecipes: filtered));
  }

  void _onSortRecipe(SortRecipe event, Emitter<RecipesState> emit) {
    if (state is! RecipesSuccess) return;

    final current = state as RecipesSuccess;
    final list = List<Recipe>.from(current.filteredRecipes);

    switch (event.type) {
      case "name":
        list.sort((a, b) {
          final nameA = a.name?.toLowerCase() ?? "";
          final nameB = b.name?.toLowerCase() ?? "";
          return nameA.compareTo(nameB);
        });
        break;

      case "calories":
        list.sort((a, b) {
          final calA = a.caloriesPerServing ?? 0;
          final calB = b.caloriesPerServing ?? 0;
          return calA.compareTo(calB);
        });
        break;

      default:
        break;
    }

    emit(current.copyWith(filteredRecipes: list));
  }
}

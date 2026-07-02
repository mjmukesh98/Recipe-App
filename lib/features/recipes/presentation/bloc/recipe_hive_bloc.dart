import 'package:demo/features/recipes/data/repository/recipes_hive_repository.dart';
import 'package:demo/features/recipes/presentation/bloc/recipe_hive_event.dart';
import 'package:demo/features/recipes/presentation/bloc/recipe_hive_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeBloc extends Bloc<RecipeHiveEvent, RecipeHiveState> {
  final RecipesHiveRepository repo;

  RecipeBloc(this.repo) : super(RecipeHiveState([])) {
    on<LoadHiveRecipes>((event, emit) {
      emit(RecipeHiveState(repo.getAll()));
    });

    on<AddHiveRecipe>((event, emit) async {
      await repo.addRecipe(event.recipe);
      emit(RecipeHiveState(repo.getAll()));
    });

    on<DeleteHiveRecipe>((event, emit) async {
      await repo.deleteRecipe(event.id);
      emit(RecipeHiveState(repo.getAll()));
    });
  }
}

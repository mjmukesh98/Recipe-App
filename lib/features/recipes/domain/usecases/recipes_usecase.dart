import 'package:demo/features/recipes/data/models/RecipesModel.dart';
import 'package:demo/features/recipes/data/repository/RecipesRepository.dart';

class RecipesUseCase {
  final RecipesRepository repository;

  RecipesUseCase(this.repository);

  Future<RecipesModel> recipes() {
    return repository.recipes();
  }

  Future<Recipe> recipesId({int? id}) {
    return repository.recipesId(id: id);
  }
}

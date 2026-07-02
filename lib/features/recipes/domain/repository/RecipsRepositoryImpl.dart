import 'package:demo/features/recipes/data/datasource/recipes_remote_datasource.dart';
import 'package:demo/features/recipes/data/models/RecipesModel.dart';
import 'package:demo/features/recipes/data/repository/RecipesRepository.dart';

class RecipesRepositoryImpl implements RecipesRepository {
  final RecipesRemoteDataSource remote;

  RecipesRepositoryImpl(this.remote);

  @override
  Future<RecipesModel> recipes() {
    final recipe = remote.recipes();
    return recipe;
  }
}

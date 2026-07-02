import 'package:demo/features/recipes/data/models/RecipesModel.dart';

abstract class RecipesRepository {
  Future<RecipesModel> recipes();
}

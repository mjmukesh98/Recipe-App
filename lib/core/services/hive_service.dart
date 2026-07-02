import 'package:demo/core/constants/hive_boxes.dart';
import 'package:demo/features/recipes/data/models/RecipesHiveModel.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._();

  static late Box<RecipeHiveModel> recipesBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(RecipeHiveModelAdapter());

    recipesBox = await Hive.openBox<RecipeHiveModel>(HiveBoxes.recipes);
  }
}

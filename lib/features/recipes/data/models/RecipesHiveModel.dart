import 'package:hive/hive.dart';
part 'RecipesHiveModel.g.dart';
@HiveType(typeId: 1)
class RecipeHiveModel extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final List<String>? ingredients;

  @HiveField(3)
  final List<String>? instructions;

  @HiveField(4)
  final int? prepTimeMinutes;

  @HiveField(5)
  final int? cookTimeMinutes;

  @HiveField(6)
  final int? servings;

  @HiveField(7)
  final String? difficulty;

  @HiveField(8)
  final String? cuisine;

  @HiveField(9)
  final int? caloriesPerServing;

  @HiveField(10)
  final List<String>? tags;

  @HiveField(11)
  final int? userId;

  @HiveField(12)
  final String? image;

  @HiveField(13)
  final double? rating;

  @HiveField(14)
  final int? reviewCount;

  @HiveField(15)
  final List<String>? mealType;

  @HiveField(15)
  bool? isFavorite;

  RecipeHiveModel({
    this.id,
    this.name,
    this.ingredients,
    this.instructions,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.servings,
    this.difficulty,
    this.cuisine,
    this.caloriesPerServing,
    this.tags,
    this.userId,
    this.image,
    this.rating,
    this.reviewCount,
    this.mealType,
    this.isFavorite = false,
  });

  // API → Model
  factory RecipeHiveModel.fromMap(Map<String, dynamic> json) {
    return RecipeHiveModel(
      id: json["id"],
      name: json["name"],
      ingredients: List<String>.from(json["ingredients"] ?? []),
      instructions: List<String>.from(json["instructions"] ?? []),
      prepTimeMinutes: json["prepTimeMinutes"],
      cookTimeMinutes: json["cookTimeMinutes"],
      servings: json["servings"],
      difficulty: json["difficulty"],
      cuisine: json["cuisine"],
      caloriesPerServing: json["caloriesPerServing"],
      tags: List<String>.from(json["tags"] ?? []),
      userId: json["userId"],
      image: json["image"],
      rating: (json["rating"] ?? 0).toDouble(),
      reviewCount: json["reviewCount"],
      mealType: List<String>.from(json["mealType"] ?? []),
      isFavorite: json["isFavorite"] ?? false,
    );
  }

  // Model → Map (for API or debugging)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "ingredients": ingredients,
      "instructions": instructions,
      "prepTimeMinutes": prepTimeMinutes,
      "cookTimeMinutes": cookTimeMinutes,
      "servings": servings,
      "difficulty": difficulty,
      "cuisine": cuisine,
      "caloriesPerServing": caloriesPerServing,
      "tags": tags,
      "userId": userId,
      "image": image,
      "rating": rating,
      "reviewCount": reviewCount,
      "mealType": mealType,
      "isFavorite": isFavorite,
    };
  }

  RecipeHiveModel copyWith({bool? isFavorite}) {
    return RecipeHiveModel(
      id: id,
      name: name,
      ingredients: ingredients,
      instructions: instructions,
      prepTimeMinutes: prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes,
      servings: servings,
      difficulty: difficulty,
      cuisine: cuisine,
      caloriesPerServing: caloriesPerServing,
      tags: tags,
      userId: userId,
      image: image,
      rating: rating,
      reviewCount: reviewCount,
      mealType: mealType,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

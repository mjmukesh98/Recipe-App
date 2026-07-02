// To parse this JSON data, do
//
//     final recipesModel = recipesModelFromMap(jsonString);

import 'dart:convert';

RecipesModel recipesModelFromMap(String str) =>
    RecipesModel.fromMap(json.decode(str));

String recipesModelToMap(RecipesModel data) => json.encode(data.toMap());

class RecipesModel {
  final List<Recipe>? recipes;
  final int? total;
  final int? skip;
  final int? limit;

  RecipesModel({this.recipes, this.total, this.skip, this.limit});

  factory RecipesModel.fromMap(Map<String, dynamic> json) => RecipesModel(
    recipes: json["recipes"] == null
        ? []
        : List<Recipe>.from(json["recipes"]!.map((x) => Recipe.fromMap(x))),
    total: json["total"],
    skip: json["skip"],
    limit: json["limit"],
  );

  Map<String, dynamic> toMap() => {
    "recipes": recipes == null
        ? []
        : List<dynamic>.from(recipes!.map((x) => x.toMap())),
    "total": total,
    "skip": skip,
    "limit": limit,
  };
}

class Recipe {
  final int? id;
  final String? name;
  final List<String>? ingredients;
  final List<String>? instructions;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final int? servings;
  final String? difficulty;
  final String? cuisine;
  final int? caloriesPerServing;
  final List<String>? tags;
  final int? userId;
  final String? image;
  final double? rating;
  final int? reviewCount;
  final List<String>? mealType;
  final bool? isFavorite; // Added detail
  Recipe({
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
    this.isFavorite,
  });

  factory Recipe.fromMap(Map<String, dynamic> json) => Recipe(
    id: json["id"],
    name: json["name"],
    ingredients: json["ingredients"] == null
        ? []
        : List<String>.from(json["ingredients"]!.map((x) => x)),
    instructions: json["instructions"] == null
        ? []
        : List<String>.from(json["instructions"]!.map((x) => x)),
    prepTimeMinutes: json["prepTimeMinutes"],
    cookTimeMinutes: json["cookTimeMinutes"],
    servings: json["servings"],
    difficulty: json["difficulty"],
    cuisine: json["cuisine"],
    caloriesPerServing: json["caloriesPerServing"],
    tags: json["tags"] == null
        ? []
        : List<String>.from(json["tags"]!.map((x) => x)),
    userId: json["userId"],
    image: json["image"],
    rating: json["rating"]?.toDouble(),
    reviewCount: json["reviewCount"],
    isFavorite: json["isFavorite"],
    mealType: json["mealType"] == null
        ? []
        : List<String>.from(json["mealType"]!.map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "ingredients": ingredients == null
        ? []
        : List<dynamic>.from(ingredients!.map((x) => x)),
    "instructions": instructions == null
        ? []
        : List<dynamic>.from(instructions!.map((x) => x)),
    "prepTimeMinutes": prepTimeMinutes,
    "cookTimeMinutes": cookTimeMinutes,
    "servings": servings,
    "difficulty": difficulty,
    "cuisine": cuisine,
    "caloriesPerServing": caloriesPerServing,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "userId": userId,
    "image": image,
    "rating": rating,
    "reviewCount": reviewCount,
    "isFavorite": isFavorite,
    "mealType": mealType == null
        ? []
        : List<dynamic>.from(mealType!.map((x) => x)),
  };
}

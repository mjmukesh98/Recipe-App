
import 'package:demo/core/constants/app_constants.dart';
import 'package:demo/core/theme/app_colors.dart';
import 'package:demo/features/recipes/data/models/RecipesModel.dart';
import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // ================= HEADER IMAGE =================
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppColors.gradientMid,
              iconTheme: const IconThemeData(
                size: 30,
                color: AppColors.primary, // Back button color
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: recipe.image ?? recipe.name ?? "",
                  child: recipe.image == null || recipe.image!.isEmpty
                      ? Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green.shade50,
                    child: const Center(
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        size: 100,
                        color: Colors.green,
                      ),
                    ),
                  )
                      : Image.network(
                    recipe.image!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.green.shade50,
                        child: const Center(
                          child: Icon(
                            Icons.restaurant_menu_rounded,
                            size: 100,
                            color: Colors.green,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ================= CONTENT =================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
                    Text(
                      recipe.name ?? "",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // TAGS ROW
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _chip("${AppStrings.emojiCuisine} ${recipe.cuisine}"),
                        _chip(
                          "${AppStrings.emojiTime} ${recipe.prepTimeMinutes} ${recipe.cookTimeMinutes} min",
                        ),
                        _chip(
                          "${AppStrings.emojiFire} ${recipe.caloriesPerServing} ${AppStrings.kcalUnit}",
                        ),
                        _chip("${AppStrings.emojiStar} ${recipe.rating}"),
                        _chip(
                          "${AppStrings.emojiPeople} ${recipe.servings} ${AppStrings.servings}",
                        ),
                        _chip(recipe.difficulty ?? ""),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // DESCRIPTION SECTION
                    const Text(
                      AppStrings.recipeInfo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _infoBox(context, [
                      "${AppStrings.prepTime} ${recipe.prepTimeMinutes} min",
                      "${AppStrings.cookTime} ${recipe.cookTimeMinutes} min",
                      "${AppStrings.reviews} ${recipe.reviewCount}",
                      "${AppStrings.tags} ${recipe.tags?.join(', ')}",
                      "${AppStrings.mealType} ${recipe.mealType?.join(', ')}",
                    ]),

                    const SizedBox(height: 20),

                    // INGREDIENTS
                    const Text(
                      AppStrings.ingredients,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _listBox(context, recipe.ingredients ?? []),

                    const SizedBox(height: 20),

                    // INSTRUCTIONS
                    const Text(
                      AppStrings.instructions,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _listBox(context, recipe.instructions ?? []),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CHIP =================
  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.green.shade800,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ================= INFO BOX =================
  Widget _infoBox(BuildContext context, List<String> items) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  "• $e",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ================= LIST BOX =================
  Widget _listBox(BuildContext context, List<String> items) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final value = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              "$index. $value",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

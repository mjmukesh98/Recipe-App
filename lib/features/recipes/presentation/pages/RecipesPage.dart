import 'package:demo/core/constants/app_constants.dart';
import 'package:demo/core/services/app_prefernces.dart';
import 'package:demo/core/services/network_service.dart';
import 'package:demo/core/theme/app_colors.dart';
import 'package:demo/core/utils/Toasters.dart';
import 'package:demo/core/widgets/app_bloc_listener.dart';
import 'package:demo/core/widgets/app_drawer.dart';
import 'package:demo/features/recipes/data/models/RecipesModel.dart';
import 'package:demo/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:demo/features/recipes/presentation/bloc/recipe_event.dart';
import 'package:demo/features/recipes/presentation/bloc/recipe_state.dart';
import 'package:demo/features/recipes/presentation/widgets/ModernSearchBar.dart';
import 'package:demo/features/recipes/presentation/widgets/RecipeSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  String username = AppPreference.getString(AppStrings.fullName) ?? "User";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final isConnected = await NetworkService().checkConnection();

    if (!isConnected) {
      context.read<RecipeBloc>().add(GetRecipe());
    } else {
      context.read<RecipeBloc>().add(LoadLocalRecipe());
    }
  }

  Widget foodCard(
    BuildContext context,
    Recipe food, {
    VoidCallback? onFavoriteTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: food)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- IMAGE SECTION WITH FLOATING OVERLAYS ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Hero(
                    tag: food.image ?? food.name ?? UniqueKey().toString(),
                    child: Image.network(
                      food.image ?? "",
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,

                      /// --- SHOWS THE ICON placeholder WHILE LOADING ---
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // Image is fully loaded
                        }
                        return Container(
                          height: 140,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.green.shade50,
                          child: const Center(
                            child: Icon(
                              Icons.restaurant_menu_rounded,
                              size: 44,
                              color: Colors.green,
                            ),
                          ),
                        );
                      },

                      /// --- SHOWS THE SAME ICON IF LOADING FAILS ---
                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 140,
                          color: Colors.green.shade50,
                          child: const Icon(
                            Icons.restaurant_menu_rounded,
                            size: 44,
                            color: Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                /// GRADIENT OVERLAY FOR READABILITY
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),

                /// RATING BADGE (TOP RIGHT)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          food.rating?.toStringAsFixed(1) ?? "0.0",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// FAVORITE TOGGLE BUTTON (TOP LEFT)
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        (food.isFavorite ?? false)
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        size: 16,
                        color: (food.isFavorite ?? false)
                            ? Colors.red
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),

                /// PREPARATION TIME OVERLAY (BOTTOM LEFT)
                Positioned(
                  bottom: 8,
                  left: 12,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${food.prepTimeMinutes ?? 15} mins",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// --- DETAILS & META INFO SECTION (FLEXIBLE & OVERFLOW PROOF) ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // Pushes bottom row perfectly down
                  children: [
                    // Wrap text fields in a scrollable view or strict flex structure
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// TAGS ROW (CUISINE & DIFFICULTY)
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    (food.cuisine ?? "General").toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    (food.difficulty ?? "Easy").toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.orange.shade800,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            /// RECIPE NAME
                            Text(
                              food.name ?? "Delicious Recipe",
                              maxLines: 2, // Allowed 2 lines safely now
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// CALORIES & NAVIGATION ROW
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                size: 14,
                                color: Colors.red.shade400,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                "${food.caloriesPerServing ?? 0} kcal",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBlocListener(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: AppDrawer(),
        appBar: AppBar(
          elevation: 4,
          centerTitle: true,
          backgroundColor: AppColors.gradientMid,
          iconTheme: const IconThemeData(
            color: AppColors.primary, // Drawer (hamburger) icon color
          ),
          title: Row(
            children: [
              const Icon(
                Icons.restaurant_rounded,
                color: AppColors.primary,
                size: 28,
              ),

              const SizedBox(width: 10),

              Text(
                textAlign: TextAlign.center,
                AppStrings.appName,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),

          actions: [
            Container(
              margin: const EdgeInsets.only(right: 12),

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Image.asset("assets/appLogo.png"),
              ),
            ),
          ],
        ),

        body: BlocListener<RecipeBloc, RecipesState>(
          listener: (context, state) {
            if (state is RecipesFailure) {
              Toasters.showToaster(context, text: state.message);
            }
          },

          child: BlocBuilder<RecipeBloc, RecipesState>(
            builder: (context, state) {
              return SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final isConnected = await NetworkService()
                        .checkConnection();

                    if (!isConnected) {
                      context.read<RecipeBloc>().add(RefreshRecipe());
                    } else {
                      context.read<RecipeBloc>().add(LoadLocalRecipe());
                    }
                    return Future.value();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "${AppStrings.hello} $username ${AppStrings.emojiHello}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),
                        if (state is RecipesSuccess)
                          Row(
                            children: [
                              // SORT
                              Expanded(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),

                                  onTap: () {
                                    context.read<RecipeBloc>().add(
                                      SortRecipe("name"),
                                    );
                                  },

                                  child: Container(
                                    height: 48,

                                    decoration: BoxDecoration(
                                      color: Colors.white,

                                      borderRadius: BorderRadius.circular(14),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.08),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),

                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        Icon(
                                          Icons.sort_rounded,
                                          color: Colors.green,
                                        ),

                                        SizedBox(width: 8),

                                        Text(
                                          "Sort A-Z",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // FILTER
                              Expanded(
                                child: PopupMenuButton<String>(
                                  offset: const Offset(0, 55),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),

                                  onSelected: (value) {
                                    context.read<RecipeBloc>().add(
                                      FilterRecipe(value),
                                    );
                                  },

                                  itemBuilder: (context) {
                                    final cuisines =
                                        state.showRecipesList
                                            .map((e) => e.cuisine)
                                            .whereType<String>()
                                            .toSet()
                                            .toList() ??
                                        [];

                                    return [
                                      PopupMenuItem<String>(
                                        value: "",

                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.clear,
                                              color: Colors.red,
                                            ),

                                            const SizedBox(width: 8),

                                            const Text("All"),
                                          ],
                                        ),
                                      ),

                                      ...cuisines.map((cuisine) {
                                        return PopupMenuItem<String>(
                                          value: cuisine,

                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.restaurant,
                                                color: Colors.green,
                                              ),

                                              const SizedBox(width: 8),

                                              Text(cuisine),
                                            ],
                                          ),
                                        );
                                      }),
                                    ];
                                  },

                                  child: Container(
                                    height: 48,

                                    decoration: BoxDecoration(
                                      color: Colors.green,

                                      borderRadius: BorderRadius.circular(14),
                                    ),

                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        Icon(
                                          Icons.filter_alt,
                                          color: Colors.white,
                                        ),

                                        SizedBox(width: 8),

                                        Text(
                                          "Filter",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 20),

                        ModernSearchBar(
                          onChanged: (value) {
                            context.read<RecipeBloc>().add(SearchRecipe(value));
                          },
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          AppStrings.popularFoods,

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          child: Builder(
                            builder: (context) {
                              if (state is RecipesLoading) {
                                return const RecipeSkeleton();
                              }

                              if (state is RecipesSuccess) {
                                final recipes = state.filteredRecipes;

                                if (recipes.isEmpty) {
                                  return const Center(
                                    child: Text("No recipes found"),
                                  );
                                }

                                return GridView.builder(
                                  itemCount: recipes.length,

                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,

                                        mainAxisSpacing: 15,

                                        crossAxisSpacing: 15,

                                        childAspectRatio: .72,
                                      ),

                                  itemBuilder: (_, index) {
                                    return foodCard(
                                      context,
                                      recipes[index],
                                      onFavoriteTap: () {},
                                    );
                                  },
                                );
                              }

                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Animated looking icon container
                                      Container(
                                        height: 140,
                                        width: 140,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primary.withOpacity(
                                                0.12,
                                              ),
                                              AppColors.primary.withOpacity(
                                                0.04,
                                              ),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withOpacity(0.12),
                                              blurRadius: 25,
                                              spreadRadius: 2,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.restaurant_menu_rounded,
                                          size: 70,
                                          color: AppColors.primary,
                                        ),
                                      ),

                                      const SizedBox(height: 32),

                                      const Text(
                                        "Oops! No Recipes Found",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      Text(
                                        "We couldn't find any recipes matching your search.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: AppColors.textSecondary,
                                          height: 1.6,
                                        ),
                                      ),

                                      const SizedBox(height: 30),

                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            context.read<RecipeBloc>().add(
                                              LoadLocalRecipe(),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.refresh_rounded,
                                          ),
                                          label: const Text(
                                            "Refresh",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: Colors.white,
                                            elevation: 4,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

//
// ===================== DETAIL PAGE =====================
//

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

                    _infoBox([
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

                    _listBox(recipe.ingredients ?? []),

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

                    _listBox(recipe.instructions ?? []),
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
  Widget _infoBox(List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text("• $e"),
              ),
            )
            .toList(),
      ),
    );
  }

  // ================= LIST BOX =================
  Widget _listBox(List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final value = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text("$index. $value", style: const TextStyle(height: 1.4)),
          );
        }).toList(),
      ),
    );
  }
}

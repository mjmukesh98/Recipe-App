import 'package:demo/features/auth/presentation/pages/login_page.dart';
import 'package:demo/features/recipes/presentation/pages/RecipesPage.dart';
 import 'package:demo/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';


import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );

      case RouteNames.recipes:
        return MaterialPageRoute(
          builder: (_) => const RecipePage(),
        );

      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route not found")),
          ),
        );
    }
  }
}
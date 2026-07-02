import 'package:demo/core/routes/app_router.dart';
import 'package:demo/core/routes/route_names.dart';
import 'package:demo/core/theme/app_theme.dart';
import 'package:demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demo/features/network/network_bloc.dart';
import 'package:demo/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:demo/features/splash/presentation/pages/splash_page.dart';
import 'package:demo/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:demo/features/theme/presentation/bloc/theme_state.dart';
import 'package:demo/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<RecipeBloc>(create: (_) => sl<RecipeBloc>()),
        BlocProvider(create: (_) => NetworkBloc()),
        BlocProvider(create: (_) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            home: const SplashPage(),
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: RouteNames.splash,
          );
        },
      ),
    );
  }
}
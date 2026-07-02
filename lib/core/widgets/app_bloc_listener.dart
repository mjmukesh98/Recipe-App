import 'package:demo/core/constants/app_constants.dart';
import 'package:demo/core/utils/Toasters.dart';
import 'package:demo/features/network/network_bloc.dart';
import 'package:demo/features/network/network_state.dart';
import 'package:demo/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:demo/features/recipes/presentation/bloc/recipe_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocListener extends StatelessWidget {
  final Widget child;

  const AppBlocListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkBloc, NetworkState>(
      listenWhen: (previous, current) {
        // ignore first state
        if (previous is NetworkInitialState) {
          return false;
        }

        return previous.runtimeType != current.runtimeType;
      },

      listener: (context, state) {
        if (state is NetworkOfflineState) {
          Toasters.showToaster(context, text: AppStrings.networkOff);
          context.read<RecipeBloc>().add(LoadLocalRecipe());
        }

        if (state is NetworkOnlineState) {
          Toasters.showToaster(context, text: AppStrings.networkOn);
          context.read<RecipeBloc>().add(GetRecipe());
        }
      },

      child: child,
    );
  }
}

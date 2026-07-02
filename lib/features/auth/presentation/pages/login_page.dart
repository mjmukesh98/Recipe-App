import 'package:demo/core/constants/app_constants.dart';
import 'package:demo/core/theme/app_colors.dart';
import 'package:demo/core/utils/Toasters.dart';
import 'package:demo/core/widgets/app_bloc_listener.dart';
import 'package:demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demo/features/auth/presentation/bloc/auth_event.dart';
import 'package:demo/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    // 👇 CLOSE KEYBOARD
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
  }

  void _goToHome() {
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, "/recipes");
  }

  @override
  Widget build(BuildContext context) {
    return AppBlocListener(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(AppStrings.success)));

              // 🔥 NAVIGATE TO HOME AFTER SUCCESS
              _goToHome();
            }

            if (state is AuthFailure) {
              Toasters.showToaster(context, text: state.message);
            }
          },
          builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.gradientStart,
                    AppColors.gradientMid,
                    AppColors.gradientEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset("assets/appLogo.png"),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        AppStrings.appName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        AppStrings.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 15,
                                offset: Offset(0, 8),
                                color: Colors.black26,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // USERNAME
                              TextFormField(
                                controller: usernameController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person),
                                  labelText: AppStrings.usernameHint,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return AppStrings.enterUsername;
                                  }
                                  if (value.length < 3) {
                                    return "Username too short";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 15),

                              // PASSWORD
                              TextFormField(
                                controller: passwordController,

                                obscureText: state is AuthInitial
                                    ? state.obscurePassword
                                    : true,

                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _login(context),

                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock),

                                  labelText: AppStrings.passwordHint,

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      context.read<AuthBloc>().add(
                                        TogglePasswordVisibility(),
                                      );
                                    },

                                    icon: Icon(
                                      state is AuthInitial &&
                                              state.obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.enterPassword;
                                  }

                                  if (value.length < 4) {
                                    return "Password too short";
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 25),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: state is AuthLoading
                                      ? null
                                      : () => _login(context),
                                  child: state is AuthLoading
                                      ? const CircularProgressIndicator(
                                          color: AppColors.white,
                                        )
                                      : const Text(
                                          AppStrings.login,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        AppStrings.testCred,
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

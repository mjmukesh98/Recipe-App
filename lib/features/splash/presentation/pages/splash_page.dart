import 'package:demo/core/constants/app_constants.dart';
import 'package:demo/core/services/secure_storage_service.dart';
import 'package:demo/core/theme/app_colors.dart';
import 'package:demo/core/widgets/app_bloc_listener.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2400));

    final token = await SecureStorageService.getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, "/recipes");
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBlocListener(
      child: Scaffold(
        backgroundColor: const Color(0xffF7FAF8),

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.splashGradientStart,
                AppColors.splashGradientMid,
                AppColors.splashGradientEnd,
              ],

              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,

              child: ScaleTransition(
                scale: _scaleAnimation,

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Container(
                      padding: const EdgeInsets.all(25),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        shape: BoxShape.circle,

                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.15),

                            blurRadius: 25,

                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),

                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.width * 0.45,
                        child: Image.asset(
                          "assets/appLogo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      AppStrings.appName,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        AppStrings.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, child) {
                        return SizedBox(
                          width: 80,
                          height: 80,

                          child: Stack(
                            alignment: Alignment.center,

                            children: [
                              CircularProgressIndicator(
                                value: value,
                                strokeWidth: 5,

                                backgroundColor: AppColors.primaryLight,

                                valueColor: const AlwaysStoppedAnimation(
                                  AppColors.primary,
                                ),
                              ),

                              Container(
                                height: 35,
                                width: 35,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.white,

                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.greenShadow,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),

                                child: const Icon(
                                  Icons.restaurant,
                                  size: 20,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:demo/core/constants/app_constants.dart';
import 'package:demo/core/session/logout_manager.dart';
import 'package:demo/core/theme/app_colors.dart';
import 'package:demo/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:demo/features/theme/presentation/bloc/theme_event.dart';
import 'package:demo/features/theme/presentation/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final themeNotifier = ValueNotifier(ThemeMode.light);
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.width * 0.45,
                      child: Image.asset(
                        "assets/appLogo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    AppStrings.appName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Cook • Explore • Enjoy",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryDark,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Home
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(Icons.home_rounded, color: Color(0xFF4CAF50)),
              ),
              title: const Text(
                "Home",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.pop(context),
            ),

            const Divider(indent: 16, endIndent: 16),

            // Dark Mode
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return SwitchListTile(
                  title: const Text(
                    "Theme Change",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  value: state.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    context.read<ThemeBloc>().add(
                      ChangeThemeEvent(
                        value ? ThemeMode.dark : ThemeMode.light,
                      ),
                    );
                  },
                );
              },
            ),

            const Spacer(),

            const Divider(),

            // Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: AppColors.primaryLight,
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.primary,
                  ),
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.primary,
                ),
                onTap: () {
                  logout(context);
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          title: Row(
            children: [
              Icon(Icons.logout_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text("Logout"),
            ],
          ),

          content: const Text("Are you sure you want to logout?"),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),

              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    await LogoutManager.logout(context);
  }
}

import 'package:demo/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';


class Toasters {
  static void showToaster(BuildContext context, {required String text}) {
    showToastWidget(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,

          borderRadius: BorderRadius.circular(8),

          border: Border.all(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/appLogo.png",
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: MediaQuery.of(context).size.width > 600
                    ? 25
                    : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      context: context,
      duration: const Duration(seconds: 3),
      position: StyledToastPosition.center,
      animation: StyledToastAnimation.none,
      reverseAnimation: StyledToastAnimation.fade,
      animDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}


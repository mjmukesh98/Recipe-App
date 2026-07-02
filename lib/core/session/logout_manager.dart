import 'package:flutter/material.dart';

import '../services/app_prefernces.dart';
import '../services/secure_storage_service.dart';
import '../session/session_manager.dart';

class LogoutManager {
  static Future<void> logout(BuildContext context) async {
    await AppPreference.clear();

    await SessionManager.clearSession();

    await SecureStorageService.clearAll();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class AppPreference{
  static SharedPreferences? prefs;

  static  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static set(String key, dynamic value) async {
    if (value is String) {
      await prefs?.setString(key, value);
    } else if (value is int) {
      await prefs?.setInt(key, value);
    } else if (value is bool) {
      await prefs?.setBool(key, value);
    } else if (value is double) {
      await prefs?.setDouble(key, value);
    }
  }

  static getString(String key) {
    return prefs?.getString(key);
  }

  /// Reads an ID stored as either String or int (some APIs return numeric ids).
  static String? getIdAsString(String key) {
    final stringValue = prefs?.getString(key);
    if (stringValue != null && stringValue.trim().isNotEmpty) {
      return stringValue.trim();
    }
    final intValue = prefs?.getInt(key);
    if (intValue != null && intValue != 0) {
      return intValue.toString();
    }
    return null;
  }

  /// Always persist ids as strings so [getString] / [getIdAsString] stay consistent.
  static Future<void> setIdAsString(String key, dynamic value) async {
    await set(key, value?.toString() ?? "");
  }


  static getInt(String key) {
    return prefs?.getInt(key) ?? 0;
  }

  static getDouble(String key) {
    return prefs?.getDouble(key);
  }

  static getBool(String key) {
    try {
      // Try to get as bool first
      final boolValue = prefs?.getBool(key);
      if (boolValue != null) {
        return boolValue;
      }
      // If not found, try to get as string and convert
      final stringValue = prefs?.getString(key);
      if (stringValue != null) {
        // Convert string to bool
        if (stringValue.toLowerCase() == 'true' || stringValue == '1') {
          return true;
        } else if (stringValue.toLowerCase() == 'false' || stringValue == '0') {
          return false;
        }
      }
      return false;
    } catch (e) {
      // If there's a type mismatch, try to get as string and convert
      try {
        final stringValue = prefs?.getString(key);
        if (stringValue != null) {
          if (stringValue.toLowerCase() == 'true' || stringValue == '1') {
            return true;
          } else if (stringValue.toLowerCase() == 'false' || stringValue == '0') {
            return false;
          }
        }
      } catch (_) {
        // Ignore and return false
      }
      return false;
    }
  }

  static remove(String key) {
    prefs?.remove(key);
  }

  static clear() async {
    await  prefs?.clear();
  }

  /// Clears every key except those persisted by the KYC verification cache
  /// (`kyc_pan_verified_*`, `kyc_dl_verified_*`, `kyc_voter_verified_*` and
  /// their `_final` variants — see ApplicationStageController._kycPrefKey).
  /// Use this on logout so a re-login on the same device keeps the verified
  /// tick state per personalId.
  static Future<void> clearExceptKyc() async {
    final p = prefs;
    if (p == null) return;
    final keys = p.getKeys().toList();
    for (final key in keys) {
      if (key.startsWith('kyc_')) continue;
      await p.remove(key);
    }
  }
}
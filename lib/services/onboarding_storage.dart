import 'package:shared_preferences/shared_preferences.dart';

class OnboardingStorage {
  static const _key = "seenOnboarding";

  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
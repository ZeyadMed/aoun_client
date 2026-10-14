import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeController {
  static const String _themeModeKey = 'theme_mode';
  static final ValueNotifier<ThemeMode> notifier = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  static Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themeModeKey) ?? 'light';
    notifier.value = _fromString(savedMode);
  }

  static Future<void> toggleTheme() async {
    final nextMode = notifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    notifier.value = nextMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _toString(nextMode));
  }

  static ThemeMode _fromString(String mode) {
    switch (mode.toLowerCase()) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  static String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
      case ThemeMode.system:
        return 'light';
    }
  }
}

import 'package:flutter/material.dart';

/// App settings: theme mode. System-driven by default (design.md §4) with a
/// manual override available in Settings.
class SettingsController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
  }
}

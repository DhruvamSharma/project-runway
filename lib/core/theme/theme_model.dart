import 'package:flutter/material.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/core/theme/theme.dart';

enum ThemeType { Light, Dark }

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme;
  ThemeType _themeType;

  ThemeModel() {
    if (!sharedPreferences.containsKey(THEME_KEY)) {
      currentTheme = darkTheme;
      _themeType = ThemeType.Dark;
    } else if (sharedPreferences.getInt(THEME_KEY) == 1) {
      currentTheme = darkTheme;
      _themeType = ThemeType.Dark;
    } else {
      currentTheme = lightTheme;
      _themeType = ThemeType.Light;
    }
  }

  toggleTheme() {
    if (_themeType == ThemeType.Dark) {
      currentTheme = lightTheme;
      _themeType = ThemeType.Light;
      sharedPreferences.setInt(THEME_KEY, 0);
      return notifyListeners();
    }

    if (_themeType == ThemeType.Light) {
      currentTheme = darkTheme;
      _themeType = ThemeType.Dark;
      sharedPreferences.setInt(THEME_KEY, 1);
      return notifyListeners();
    }
  }
}

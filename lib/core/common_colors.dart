import 'package:flutter/material.dart';

class CommonColors {
  // Theme colors
  static final Color primarySwatch = chartColor;
  static final Color accentColor = _getColor(0xffFFFFFF);
  static final Color scaffoldColor = _getColor(0xff080808);
  static final Color toggleableActiveColor = Colors.transparent;
  static final Color cursorColor = Colors.grey;

  // Text Colors

  // for dark theme
  static final Color headerTextColor = _getColor(0xffFFFFFF);
  // for light Theme
  static final Color headerTextColorLightTheme = _getColor(0xff000000);

  // for dark theme
  static final Color taskTextColor = _getColor(0xffFFFFFF);
  // for light theme
  static final Color taskTextColorLightTheme = _getColor(0xff000000);

  static final Color disabledTaskTextColor = _getColor(0xff707070);

  // for dark theme
  static final Color dateTextColor = _getColor(0xff3C3B3B);
  // for light theme
  static final Color dateTextColorLightTheme = Colors.black26;

  // for dark theme
  static final Color rotatedDesignTextColor = _getColor(0xff171616);
  // for light theme
  static final Color rotatedDesignTextColorLightTheme =
      Colors.black12.withAlpha(10);

  // for dark theme
  static final Color taskBadgeTextColor = scaffoldColor;
  // for light theme
  static final Color taskBadgeTextColorLightTheme = accentColor;
  // for dark theme
  static final Color taskBadgeColor = accentColor;
  // for light theme
  static final Color taskBadgeColorLightTheme = scaffoldColor;

  static final Color errorTextColor = Colors.red;

  // App bar colors
  static final Color appBarColor = Colors.transparent;

  static final Color smallAccentColor = chartColor;

  // bottom sheet color dark theme
  static final Color bottomSheetColor = _getColor(0xff121111);
  // bottom sheet color light theme
  static final Color bottomSheetColorLightTheme = _getColor(0xffEBEAEA);

  static final Color chartColor = _getColor(0xFF195153);

  static final Color introColor = _getColor(0xFFC1C1C1);

  static Map<int, Color> _color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  static MaterialColor _getColor(int primary) {
    return MaterialColor(primary, _color);
  }
}

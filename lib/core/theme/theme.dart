//theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_runway/core/common_colors.dart';

final TextStyle _themeTextStyle = GoogleFonts.bellotaText();
final TextTheme _themeTextTheme = GoogleFonts.bellotaTextTextTheme();

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: CommonColors.primarySwatch,
  accentColor: Colors.white,
  brightness: Brightness.light,
  textSelectionColor: CommonColors.chartColor.withOpacity(0.38),
  scaffoldBackgroundColor: CommonColors.scaffoldColor,
  canvasColor: Colors.transparent,
  iconTheme: IconThemeData(color: Colors.white.withOpacity(0.60)),
  primaryIconTheme: IconThemeData(color: Colors.white),
  accentIconTheme: IconThemeData(color: Colors.white),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: CommonColors.chartColor,
  ),
  textTheme: _themeTextTheme.copyWith(
    headline1: GoogleFonts.anton().copyWith(
        height: 1.5,
        color: CommonColors.taskTextColor,
        letterSpacing: 5,
        fontSize: 70),
    // Used for background rotated text
    headline2: GoogleFonts.anton().copyWith(
      height: 1.5,
      color: CommonColors.taskTextColor,
      letterSpacing: 5,
      fontSize: 40,
    ),
    // Used for headers
    headline3: GoogleFonts.anton().copyWith(
      height: 1.5,
      color: CommonColors.headerTextColor.withOpacity(0.38),
      letterSpacing: 14,
      fontSize: 40,
    ),
    // Used for telling scores
    headline4: _themeTextStyle.copyWith(
      height: 1.5,
      color: CommonColors.headerTextColor.withOpacity(0.60),
      letterSpacing: 10,
      fontSize: 34,
    ),
    // Used for header texts, bigger than titles
    headline5: _themeTextStyle.copyWith(
      height: 1.0,
      color: CommonColors.headerTextColor.withOpacity(0.60),
      letterSpacing: 4,
      fontSize: 24,
    ),
    // Used for task title, setting list item
    headline6: _themeTextStyle.copyWith(
      height: 1.5,
      letterSpacing: 2,
      color: CommonColors.introColor.withOpacity(0.89),
      fontSize: 20,
    ),
    button: _themeTextStyle.copyWith(
        height: 1.5,
        color: CommonColors.headerTextColor.withOpacity(0.60),
        letterSpacing: 2,
        fontSize: 14,
        fontWeight: FontWeight.w500),
    // Used for date texts, used for text field labels
    subtitle1: _themeTextStyle.copyWith(
        height: 1.5,
        color: CommonColors.headerTextColor.withOpacity(0.38),
        letterSpacing: 4,
        fontSize: 18),
    // Used for badges
    subtitle2: _themeTextStyle.copyWith(
        height: 1.5,
        color: CommonColors.headerTextColor.withOpacity(0.60),
        letterSpacing: 2,
        fontSize: 12,
        fontWeight: FontWeight.w500),
    // used for snackbars
    bodyText1: _themeTextStyle.copyWith(
      height: 1.5,
      color: CommonColors.scaffoldColor.withOpacity(0.89),
      letterSpacing: 2,
      fontSize: 14,
    ),
    bodyText2: _themeTextStyle.copyWith(
      height: 1.5,
      color: CommonColors.headerTextColor.withOpacity(0.60),
      letterSpacing: 4,
      fontSize: 12,
    ),
    // Used for badges text
    caption: _themeTextStyle.copyWith(
      height: 1.5,
      color: CommonColors.taskBadgeColor.withOpacity(0.60),
      letterSpacing: 4,
      fontSize: 14,
    ),

    // Used for asterisk notes
    overline: _themeTextStyle.copyWith(
      height: 1.5,
      color: CommonColors.taskBadgeColor.withOpacity(0.60),
      letterSpacing: 4,
    ),
  ),
  timePickerTheme: TimePickerThemeData(
    dialHandColor: CommonColors.accentColor,
  ),
  sliderTheme: SliderThemeData(
    thumbColor: CommonColors.chartColor,
    activeTrackColor: CommonColors.chartColor,
    showValueIndicator: ShowValueIndicator.always,
  ),
  inputDecorationTheme: InputDecorationTheme(
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    contentPadding: const EdgeInsets.all(0),
    border: UnderlineInputBorder(
      borderSide: BorderSide(
        color: CommonColors.accentColor,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: CommonColors.accentColor),
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: CommonColors.accentColor),
  ),
);

ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: CommonColors.primarySwatch,
  accentColor: CommonColors.scaffoldColor,
  brightness: Brightness.dark,
  iconTheme: IconThemeData(color: Colors.black26),
  primaryIconTheme: IconThemeData(color: Colors.black26),
  accentIconTheme: IconThemeData(color: Colors.black26),
  scaffoldBackgroundColor: CommonColors.accentColor,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: CommonColors.chartColor,
  ),
  sliderTheme: SliderThemeData(
      thumbColor: CommonColors.chartColor,
      activeTrackColor: CommonColors.chartColor,
      showValueIndicator: ShowValueIndicator.always),
  canvasColor: Colors.transparent,
  appBarTheme: AppBarTheme(
    elevation: 0,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: CommonColors.scaffoldColor),
  ),
  inputDecorationTheme: InputDecorationTheme(
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: CommonColors.accentColor),
    ),
    contentPadding: const EdgeInsets.all(0),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: CommonColors.accentColor),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: CommonColors.accentColor),
    ),
  ),
);

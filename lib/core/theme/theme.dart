//theme.dart

import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: CommonColors.primarySwatch,
  accentColor: Colors.white,
  brightness: Brightness.light,
  scaffoldBackgroundColor: CommonColors.scaffoldColor,
  canvasColor: Colors.transparent,
  iconTheme: IconThemeData(color: Colors.white),
  primaryIconTheme: IconThemeData(color: Colors.white),
  accentIconTheme: IconThemeData(color: Colors.white),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: CommonColors.chartColor,
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

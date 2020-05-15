import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:provider/provider.dart';

class CommonTextStyles {
  static final TextStyle _googleFontStyle = GoogleFonts.baumans();

  static TextStyle headerTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(context, listen: false).currentTheme == lightTheme
          ? CommonColors.headerTextColorLightTheme
          : CommonColors.headerTextColor,
      fontSize: 40,
      letterSpacing: 30,
    );
  }

  static TextStyle loginTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(context, listen: false).currentTheme == lightTheme
          ? CommonColors.taskTextColorLightTheme
          : CommonColors.taskTextColor,
      fontSize: 28,
      letterSpacing: 5,
    );
  }

  static TextStyle dateTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(context,).currentTheme == lightTheme
          ? CommonColors.dateTextColorLightTheme
          : CommonColors.dateTextColor,
      fontSize: 16,
      letterSpacing: 10,
    );
  }

  static TextStyle badgeTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(context,).currentTheme == lightTheme
          ? CommonColors.taskBadgeTextColorLightTheme
          : CommonColors.taskBadgeTextColor,
      fontSize: 10,
      letterSpacing: 4,
    );
  }

  static TextStyle rotatedDesignTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(context,).currentTheme == lightTheme
          ? CommonColors.rotatedDesignTextColorLightTheme
          : CommonColors.rotatedDesignTextColor,
      fontSize: 40,
      letterSpacing: 30,
    );
  }

  static TextStyle taskTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(context,).currentTheme == lightTheme
          ? CommonColors.taskTextColorLightTheme
          : CommonColors.taskTextColor,
      fontSize: 20,
      letterSpacing: 5,
    );
  }

  static TextStyle scaffoldTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(context, listen: false).currentTheme != lightTheme
          ? CommonColors.taskTextColorLightTheme
          : CommonColors.taskTextColor,
      fontSize: 14,
      letterSpacing: 2,
    );
  }

  static TextStyle disabledTaskTextStyle() {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: CommonColors.disabledTaskTextColor,
      fontSize: 20,
      letterSpacing: 5,
    );
  }

  static TextStyle errorFieldTextStyle() {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: CommonColors.errorTextColor,
      fontSize: 12,
      letterSpacing: 2,
    );
  }
}

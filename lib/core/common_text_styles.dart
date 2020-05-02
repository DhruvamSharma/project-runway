
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_runway/core/common_colors.dart';

class CommonTextStyles {
  static final TextStyle _googleFontStyle = GoogleFonts.aBeeZee();

  static TextStyle headerTextStyle() {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: CommonColors.headerTextColor,
      fontSize: 40,
      letterSpacing: 30,
    );
  }

  static TextStyle dateTextStyle() {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: CommonColors.dateTextColor,
      fontSize: 16,
      letterSpacing: 10,
    );
  }

  static TextStyle rotatedDesignTextStyle() {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: CommonColors.rotatedDesignTextColor,
      fontSize: 40,
      letterSpacing: 30,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:provider/provider.dart';

import 'date_time_parser.dart';

class CommonTextStyles {
  static final TextStyle _googleFontStyle = GoogleFonts.baumans();

  static TextStyle defineTextStyle(BuildContext context) {
    return Provider.of<ThemeModel>(context, listen: true)
        .currentTheme
        .textTheme
        .headline2;
  }

  static TextStyle headerTextStyle(BuildContext context) {
    return Provider.of<ThemeModel>(context, listen: true)
        .currentTheme
        .textTheme
        .headline3;
  }

  static TextStyle loginTextStyle(BuildContext context) {
    return Provider.of<ThemeModel>(context, listen: true)
        .currentTheme
        .textTheme
        .headline5;
  }

  static TextStyle dateTextStyle(BuildContext context) {
    return Provider.of<ThemeModel>(context, listen: true)
        .currentTheme
        .textTheme
        .subtitle1;
  }

  static TextStyle badgeTextStyle(BuildContext context) {
    return Provider.of<ThemeModel>(context, listen: true)
        .currentTheme
        .textTheme
        .subtitle2;
  }

  static TextStyle rotatedDesignTextStyle(BuildContext context) {
    return Provider.of<ThemeModel>(context, listen: true)
        .currentTheme
        .textTheme
        .headline2.copyWith(
      color: CommonColors.rotatedDesignTextColor.withOpacity(0.38)
    );
  }

  static TextStyle taskTextStyle(BuildContext context) {
    return Provider.of<ThemeModel>(context, listen: true)
        .currentTheme
        .textTheme
        .headline6;
  }

  static TextStyle scoreTextStyle(BuildContext context) {
    return Provider.of<ThemeModel>(context, listen: true)
        .currentTheme
        .textTheme
        .headline4;
  }

  static TextStyle asteriskTextStyle(BuildContext context) {
    return Provider.of<ThemeModel>(context, listen: true)
        .currentTheme
        .textTheme
        .overline;
  }

  static TextStyle settingListItemStyle(BuildContext context) {
    return Provider.of<ThemeModel>(context, listen: true)
        .currentTheme
        .textTheme
        .headline6;
  }

  static TextStyle scaffoldTextStyle(BuildContext context) {
    return Provider.of<ThemeModel>(context, listen: false)
        .currentTheme
        .textTheme
        .bodyText1;
  }

  static TextStyle textFieldLabelStyle(BuildContext context) {
    return Provider.of<ThemeModel>(context, listen: true)
        .currentTheme
        .textTheme
        .subtitle1;
  }

  static TextStyle disabledTaskTextStyle() {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: CommonColors.taskTextColor.withOpacity(0.38),
      fontSize: 20,
      letterSpacing: 2,
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

  static TextStyle buildNotificationTextColor(BuildContext context) {
    return CommonTextStyles.disabledTaskTextStyle();
  }
}

TextStyle selectTaskStyle(
    TaskEntity task, BuildContext context, bool isCompleted) {
  TextStyle taskTextStyle;
  // calculating if the task is completed
  if (isCompleted) {
    taskTextStyle = CommonTextStyles.disabledTaskTextStyle();
  } else {
    taskTextStyle = CommonTextStyles.taskTextStyle(context);
  }
  // calculating if the task is for a previous day
  if (checkIsTaskIsOfPast(task.runningDate)) {
    taskTextStyle = CommonTextStyles.disabledTaskTextStyle();
  }
  return taskTextStyle;
}

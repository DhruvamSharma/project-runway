import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:provider/provider.dart';

import 'date_time_parser.dart';

class CommonTextStyles {
  static final TextStyle _googleFontStyle = GoogleFonts.baumans();

  static TextStyle headerTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(context, listen: false).currentTheme ==
              lightTheme
          ? CommonColors.headerTextColorLightTheme.withOpacity(0.60)
          : CommonColors.headerTextColor.withOpacity(0.60),
      fontSize: 40,
      letterSpacing: 25,
    );
  }

  static TextStyle loginTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(context, listen: false).currentTheme ==
              lightTheme
          ? CommonColors.taskTextColorLightTheme
          : CommonColors.taskTextColor.withOpacity(0.87),
      fontSize: 28,
      letterSpacing: 3,
    );
  }

  static TextStyle dateTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(
                context,
              ).currentTheme ==
              lightTheme
          ? CommonColors.dateTextColorLightTheme
          : CommonColors.accentColor.withOpacity(0.38),
      fontSize: 16,
      letterSpacing: 10,
    );
  }

  static TextStyle badgeTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(
                context,
              ).currentTheme ==
              lightTheme
          ? CommonColors.taskBadgeTextColorLightTheme
          : CommonColors.taskBadgeTextColor,
      fontSize: 12,
      letterSpacing: 3,
    );
  }

  static TextStyle rotatedDesignTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      color: Provider.of<ThemeModel>(
                context,
              ).currentTheme ==
              lightTheme
          ? CommonColors.rotatedDesignTextColorLightTheme.withOpacity(0.02)
          : CommonColors.taskTextColor.withOpacity(0.01),
      fontSize: 40,
      letterSpacing: 30,
    );
  }

  static TextStyle taskTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(
                context,
              ).currentTheme ==
              lightTheme
          ? CommonColors.taskTextColorLightTheme
          : CommonColors.taskTextColor.withOpacity(0.87),
      fontSize: 20,
      letterSpacing: 2,
    );
  }

  static TextStyle scaffoldTextStyle(BuildContext context) {
    return _googleFontStyle.copyWith(
      height: 1.5,
      color: Provider.of<ThemeModel>(context, listen: false).currentTheme !=
              lightTheme
          ? CommonColors.taskTextColorLightTheme
          : CommonColors.taskTextColor,
      fontSize: 14,
      letterSpacing: 2,
    );
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
    final currentTheme =
        Provider.of<ThemeModel>(context, listen: false).currentTheme;

    if (currentTheme == lightTheme) {
      return CommonTextStyles.taskTextStyle(context).copyWith(
        color: CommonColors.scaffoldColor.withOpacity(0.38),
      );
    } else {
      return CommonTextStyles.taskTextStyle(context).copyWith(
        color: CommonColors.taskTextColor.withOpacity(0.38),
      );
    }
  }
}

TextStyle selectTaskStyle(
    TaskEntity task, BuildContext context, bool isCompleted) {
  TextStyle taskTextStyle;
  final currentTheme =
      Provider.of<ThemeModel>(context, listen: false).currentTheme;
  // calculating if the task is completed
  if (isCompleted) {
    if (currentTheme == darkTheme) {
      taskTextStyle = CommonTextStyles.disabledTaskTextStyle();
    } else {
      taskTextStyle = CommonTextStyles.taskTextStyle(context).copyWith(
        color: CommonColors.scaffoldColor.withOpacity(0.38),
      );
    }
  } else {
    taskTextStyle = CommonTextStyles.taskTextStyle(context);
  }
  // calculating if the task is for a previous day
  if (checkIsTaskIsOfPast(task.runningDate)) {
    if (currentTheme == darkTheme) {
      taskTextStyle = CommonTextStyles.disabledTaskTextStyle();
    } else {
      taskTextStyle = CommonTextStyles.taskTextStyle(context).copyWith(
        color: CommonColors.scaffoldColor.withOpacity(0.60),
      );
    }
  }
  return taskTextStyle;
}

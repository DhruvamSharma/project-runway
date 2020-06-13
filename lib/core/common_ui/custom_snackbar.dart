import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:provider/provider.dart';

class CustomSnackbar {
  static withAnimation(BuildContext context, String text) {
    return SnackBar(
      content: Text(
        text ?? "Sorry, a problem occurred",
        style: CommonTextStyles.scaffoldTextStyle(context),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor:
          Provider.of<ThemeModel>(context, listen: false).currentTheme ==
                  lightTheme
              ? CommonColors.scaffoldColor
              : CommonColors.accentColor,
    );
  }
}

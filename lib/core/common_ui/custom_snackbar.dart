import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:provider/provider.dart';

class CustomSnackbar extends SnackBar {

  final String text;
  final BuildContext context;

  CustomSnackbar(this.text, this.context);

  @override
  SnackBar withAnimation(Animation<double> newAnimation, {Key fallbackKey}) {
    print(text);
    return SnackBar(
      key: fallbackKey,
      content: Text(
        text?? "Sorry, a problem occurred",
        style: CommonTextStyles.scaffoldTextStyle(context),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor:
      Provider.of<ThemeModel>(context, listen: false).currentTheme == lightTheme
          ? CommonColors.scaffoldColor
          : CommonColors.accentColor,
    );
  }

}

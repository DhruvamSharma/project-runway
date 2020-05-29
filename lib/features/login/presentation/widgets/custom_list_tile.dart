import 'package:flutter/material.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/theme/theme_model.dart';

class CustomListTile extends StatelessWidget {
  final IconData leadingIcon;
  final Function onTap;
  final ThemeModel appState;
  final String text;
  final Widget trailing;

  CustomListTile({
    @required this.leadingIcon,
    @required this.onTap,
    @required this.appState,
    @required this.text,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(highlightColor: Colors.transparent),
      child: ListTile(
        contentPadding: const EdgeInsets.all(
          CommonDimens.MARGIN_20,
        ),
        leading: Icon(
          leadingIcon,
          color: appState.currentTheme.accentColor,
          size: 30,
        ),
        title: Text(
          text,
          style: CommonTextStyles.taskTextStyle(context),
        ),
        onTap: onTap,
        trailing: trailing,
      ),
    );
  }
}

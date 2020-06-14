import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/theme/theme_model.dart';

class CustomListTile extends StatelessWidget {
  final IconData leadingIcon;
  final Function onTap;
  final ThemeModel appState;
  final String text;
  final Widget trailing;
  final bool isNew;
  final String iconUrl;

  CustomListTile({
    this.leadingIcon,
    @required this.onTap,
    @required this.appState,
    @required this.text,
    this.isNew = false,
    this.iconUrl,
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
        leading: Stack(
          children: <Widget>[
            if (iconUrl != null)
              CachedNetworkImage(
                imageUrl: iconUrl,
                height: 30,
                width: 30,
                fit: BoxFit.fill,
                color: appState.currentTheme.iconTheme.color,
              )
            else
              Icon(
                leadingIcon,
                color: appState.currentTheme.iconTheme.color,
                size: 30,
              ),
            if (isNew)
              Positioned(
                right: 0,
                child: CircleAvatar(
                  backgroundColor: CommonColors.chartColor,
                  radius: 5,
                ),
              ),
          ],
        ),
        title: Text(
          text,
          style: CommonTextStyles.settingListItemStyle(context),
        ),
        onTap: onTap,
        trailing: trailing,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';

class AppIntroShortcutWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  AppIntroShortcutWidget({
    @required this.imageUrl,
    @required this.title,
    @required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: CommonDimens.MARGIN_20,
              ),
              child: Image.asset(
                imageUrl,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: CommonDimens.MARGIN_60,
              ),
              child: Text(
                title,
                style: CommonTextStyles.loginTextStyle(
                  context,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: CommonDimens.MARGIN_20,
                left: CommonDimens.MARGIN_20 / 2,
                right: CommonDimens.MARGIN_20 / 2,
              ),
              child: Text(
                subtitle,
                style: CommonTextStyles.taskTextStyle(context),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

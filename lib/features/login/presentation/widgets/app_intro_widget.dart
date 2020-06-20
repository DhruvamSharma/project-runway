import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: CommonDimens.MARGIN_20,
              bottom: CommonDimens.MARGIN_20,
            ),
            child: Text(
              title,
              style: CommonTextStyles.defineTextStyle(context),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                top: CommonDimens.MARGIN_20,
                left: CommonDimens.MARGIN_20,
                right: CommonDimens.MARGIN_20,
              ),
              child: Container(
                color: CommonColors.scaffoldColor,
                height: MediaQuery.of(context).size.height / 2,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: CommonColors.darkGreyColor,
                  elevation: 24,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        CommonDimens.MARGIN_20,
                      ),
                    ),
                  ),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: CommonDimens.MARGIN_40,
                            left: CommonDimens.MARGIN_20,
                            right: CommonDimens.MARGIN_20,
                          ),
                          child: Text(
                            subtitle,
                            style: CommonTextStyles.taskTextStyle(context),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: CommonDimens.MARGIN_20,
                            top: CommonDimens.MARGIN_20,
                          ),
                          child: Image.asset(
                            imageUrl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';

class AppIntro37Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "3",
                      style: CommonTextStyles.loginTextStyle(context)
                          .copyWith(fontSize: 90)
                          .copyWith(color: CommonColors.introColor),
                    ),
                    TextSpan(
                      text: " : ",
                      style: CommonTextStyles.loginTextStyle(context).copyWith(
                          fontSize: 90, color: CommonColors.chartColor),
                    ),
                    TextSpan(
                      text: "7",
                      style: CommonTextStyles.loginTextStyle(context)
                          .copyWith(fontSize: 90)
                          .copyWith(color: CommonColors.introColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: CommonDimens.MARGIN_60,
            ),
            child: Text(
              "3:7 Rule",
              style: CommonTextStyles.loginTextStyle(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: CommonDimens.MARGIN_20,
              left: CommonDimens.MARGIN_20 / 2,
              right: CommonDimens.MARGIN_20 / 2,
            ),
            child: Text(
              "View 7 tasks for 3 days for focused prioritization of tasks",
              style: CommonTextStyles.taskTextStyle(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ));
  }
}

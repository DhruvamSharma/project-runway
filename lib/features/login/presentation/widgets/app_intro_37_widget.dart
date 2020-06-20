import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';

class AppIntro37Widget extends StatelessWidget {
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
              "The 3:7\nRule",
              style: CommonTextStyles.defineTextStyle(context),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                left: CommonDimens.MARGIN_20,
                right: CommonDimens.MARGIN_20,
                top: CommonDimens.MARGIN_20,
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
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
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
                            "View 7 tasks for 3 days for focused prioritization of tasks",
                            style: CommonTextStyles.disabledTaskTextStyle(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: CommonDimens.MARGIN_40,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "3",
                                    style:
                                        CommonTextStyles.loginTextStyle(context)
                                            .copyWith(fontSize: 90)
                                            .copyWith(
                                                fontWeight: FontWeight.w900,
                                                color: CommonColors.introColor),
                                  ),
                                  TextSpan(
                                    text: " : ",
                                    style:
                                        CommonTextStyles.loginTextStyle(context)
                                            .copyWith(
                                                fontSize: 90,
                                                fontWeight: FontWeight.w900,
                                                color: CommonColors.chartColor),
                                  ),
                                  TextSpan(
                                    text: "7",
                                    style:
                                        CommonTextStyles.loginTextStyle(context)
                                            .copyWith(fontSize: 90)
                                            .copyWith(
                                                fontWeight: FontWeight.w900,
                                                color: CommonColors.introColor),
                                  ),
                                ],
                              ),
                            ),
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

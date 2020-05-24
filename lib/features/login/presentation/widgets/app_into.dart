import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppIntroWidget extends StatelessWidget {
  static const String routeName = "${APP_NAME}_v1_user_profile-intro";

  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: CommonDimens.MARGIN_60,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Runway".toUpperCase(),
                style: CommonTextStyles.headerTextStyle(context),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: CommonDimens.MARGIN_20,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 400,
                      child: PageView(
                        controller: _controller,
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          Center(
                              child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: CommonDimens.MARGIN_20,
                                  ),
                                  child: Image.asset(
                                    "assets/intro_pedestal.png",
                                    height: 200,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: CommonDimens.MARGIN_20,
                                  ),
                                  child: Text(
                                    "Foccused Approach",
                                    style:
                                        CommonTextStyles.loginTextStyle(context),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: CommonDimens.MARGIN_20,
                                    left: CommonDimens.MARGIN_20 / 2,
                                    right: CommonDimens.MARGIN_20 / 2,
                                  ),
                                  child: Text(
                                    "Reward-based minimal design to enhance your decisiveness",
                                    style:
                                        CommonTextStyles.taskTextStyle(context),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )),
                          Center(
                              child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  "assets/intro_graph.png",
                                  height: 200,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: CommonDimens.MARGIN_20,
                                  ),
                                  child: Text(
                                    "Visualise Growth",
                                    style:
                                        CommonTextStyles.loginTextStyle(context),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: CommonDimens.MARGIN_20,
                                    left: CommonDimens.MARGIN_20 / 2,
                                    right: CommonDimens.MARGIN_20 / 2,
                                  ),
                                  child: Text(
                                    "Track your progress through exclusive statistics",
                                    style:
                                        CommonTextStyles.taskTextStyle(context),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )),
                          Center(
                              child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "3",
                                            style: CommonTextStyles
                                                    .loginTextStyle(context)
                                                .copyWith(fontSize: 90)
                                                .copyWith(
                                                    color:
                                                        CommonColors.introColor),
                                          ),
                                          TextSpan(
                                            text: " : ",
                                            style: CommonTextStyles
                                                    .loginTextStyle(context)
                                                .copyWith(
                                                    fontSize: 90,
                                                    color:
                                                        CommonColors.chartColor),
                                          ),
                                          TextSpan(
                                            text: "7",
                                            style: CommonTextStyles
                                                    .loginTextStyle(context)
                                                .copyWith(fontSize: 90)
                                                .copyWith(
                                                    color:
                                                        CommonColors.introColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: CommonDimens.MARGIN_20,
                                  ),
                                  child: Text(
                                    "3:7 Rule",
                                    style:
                                        CommonTextStyles.loginTextStyle(context),
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
                                    style:
                                        CommonTextStyles.taskTextStyle(context),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )),
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/intro_puzzle.png",
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: CommonDimens.MARGIN_20,
                                    ),
                                    child: Text(
                                      "Secret Puzzles",
                                      style: CommonTextStyles.loginTextStyle(
                                          context),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: CommonDimens.MARGIN_20,
                                      left: CommonDimens.MARGIN_20 / 2,
                                      right: CommonDimens.MARGIN_20 / 2,
                                    ),
                                    child: Text(
                                      "Exercise your intellectual efficiency through puzzles",
                                      style:
                                          CommonTextStyles.taskTextStyle(context),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: 4,
                        effect: ExpandingDotsEffect(
                          radius: 10,
                          dotHeight: 7,
                          dotWidth: 7,
                          activeDotColor: CommonColors.chartColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

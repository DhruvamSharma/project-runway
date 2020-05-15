import 'package:flutter/material.dart';
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
    final appState = Provider.of<ThemeModel>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Runway".toUpperCase(),
          style: CommonTextStyles.headerTextStyle(context),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: CommonDimens.MARGIN_60,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.width,
                child: PageView(
                  controller: _controller,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Center(
                        child: Column(
                      children: <Widget>[
                        Image.asset(
                          appState.currentTheme == lightTheme
                              ? "assets/intro_pedestal_light.png"
                              : "assets/intro_pedestal_dark.png",
                          height: 200,
                        ),
                        Text(
                          "Productivity",
                          style: CommonTextStyles.loginTextStyle(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Create the runway for improved productivity",
                            style: CommonTextStyles.taskTextStyle(context),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                    Center(
                        child: Column(
                      children: <Widget>[
                        Image.asset(
                          appState.currentTheme == lightTheme
                              ? "assets/intro_graph_light.png"
                              : "assets/intro_graph_dark.png",
                          height: 200,
                        ),
                        Text(
                          "Statistics",
                          style: CommonTextStyles.loginTextStyle(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Visualize your growth better",
                            style: CommonTextStyles.taskTextStyle(context),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                    Center(
                        child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              "3-7",
                              style: CommonTextStyles.headerTextStyle(context)
                                  .copyWith(
                                fontSize: 90,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "The 3-7 Rule",
                          style: CommonTextStyles.loginTextStyle(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Create only 7 tasks per day and View only 3 day tasks",
                            style: CommonTextStyles.taskTextStyle(context),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      radius: 10,
                      dotHeight: 7,
                      dotWidth: 7,
                      activeDotColor: appState.currentTheme.accentColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

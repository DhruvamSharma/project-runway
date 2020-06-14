import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/features/login/presentation/widgets/app_intro_37_widget.dart';
import 'package:project_runway/features/login/presentation/widgets/app_intro_speak_or_draw_widget.dart';
import 'package:project_runway/features/login/presentation/widgets/app_intro_vision_board_widget.dart';
import 'package:project_runway/features/login/presentation/widgets/app_intro_widget.dart';
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
                          AppIntroShortcutWidget(
                            imageUrl: "assets/intro_pedestal.png",
                            title: "Focused Approach",
                            subtitle:
                                "Reward-based minimal design to enhance your decisiveness",
                          ),
                          AppIntroSpeakOrDrawWidget(),
                          AppIntroVisionBoardWidget(),
                          AppIntroShortcutWidget(
                            imageUrl: "assets/intro_graph.png",
                            title: "Visualise Growth",
                            subtitle:
                                "Track your progress through exclusive statistics",
                          ),
                          AppIntro37Widget(),
                          AppIntroShortcutWidget(
                            imageUrl: "assets/intro_puzzle.png",
                            title: "Secret Puzzles",
                            subtitle:
                                "Exercise your intellectual efficiency through puzzles",
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: CommonDimens.MARGIN_20,
                        ),
                        child: SmoothPageIndicator(
                          controller: _controller,
                          count: 6,
                          effect: ExpandingDotsEffect(
                            radius: 10,
                            dotHeight: 7,
                            dotWidth: 7,
                            activeDotColor: CommonColors.chartColor,
                          ),
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

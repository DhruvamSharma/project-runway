import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project_runway/core/analytics_utils.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys/keys.dart';
import 'package:project_runway/core/remote_config/remote_config_service.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/login/presentation/pages/profile_route.dart';
import 'package:project_runway/features/stats/presentation/pages/stats_screen.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_page.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/vision_board_list/vision_board_list_args.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/vision_board_list/vision_board_list_route.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "${APP_NAME}_v1_task_home-screen";
  final UserEntity user;

  HomeScreen()
      : user = UserModel.fromJson(
            json.decode(sharedPreferences.getString(USER_MODEL_KEY)));
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with RouteAware, SingleTickerProviderStateMixin {
  PageController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController _animationController;
  RemoteConfigService _remoteConfigService = sl<RemoteConfigService>();
  @override
  void initState() {
    _controller = PageController(
      initialPage: 1,
    );
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 8));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    if (!_remoteConfigService.lightThemeOptionEnabled &&
        appState.currentTheme == lightTheme) {
      appState.toggleTheme();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ThemeModel>(context, listen: false);
    return ChangeNotifierProvider<HomeScreenPageControllerProvider>(
      create: (_) => HomeScreenPageControllerProvider(controller: _controller),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: CommonColors.appBarColor,
          actions: <Widget>[
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.transparent,
              child: IconButton(
                  tooltip: "Statistics",
                  icon: Icon(
                    Icons.airplanemode_active,
                    color: state.currentTheme.iconTheme.color,
                    size: 21,
                  ),
                  onPressed: () {
                    AnalyticsUtils.sendAnalyticEvent(
                        SEE_STATS_IN_HOME, {}, "HOME_SCREEN");
                    Navigator.pushNamed(context, StatsScreen.routeName);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: CommonDimens.MARGIN_20,
              ),
              child: IconButton(
                  tooltip: "Vision Board",
                  icon: CachedNetworkImage(
                    imageUrl: "https://imgur.com/XtCHimD.png",
                    color: state.currentTheme.iconTheme.color,
                    fit: BoxFit.fill,
                    height: 21,
                    width: 21,
                  ),
                  onPressed: () {
                    AnalyticsUtils.sendAnalyticEvent(
                        SEE_STATS_IN_HOME, {}, "HOME_SCREEN");
                    Navigator.pushNamed(context, VisionBoardListRoute.routeName,
                        arguments: VisionBoardListArgs(
                          _controller.page.floor(),
                        ));
                  }),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: CommonDimens.MARGIN_20, top: 2),
              child: IconButton(
                  tooltip: "Settings",
                  icon: Icon(
                    Icons.settings,
                    color: state.currentTheme.iconTheme.color,
                    size: 21,
                  ),
                  onPressed: () async {
                    AnalyticsUtils.sendAnalyticEvent(
                        OPEN_SETTINGS, {}, "HOME_SCREEN");
                    Navigator.pushNamed(context, ProfileRoute.routeName);
                  }),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  APP_NAME.toUpperCase(),
                  style: CommonTextStyles.rotatedDesignTextStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () {
                  if (!sharedPreferences.containsKey(REFRESH_KEY) &&
                      widget.user.score == null) {
                    int days = 0;
                    try {
                      days = DateTime.now()
                          .difference(widget.user.createdAt)
                          .inDays;
                    } catch (ex) {
                      // Do nothing
                    }
                    AnalyticsUtils.sendAnalyticEvent(
                        FOUND_PUZZLE, {"numberOfDays": days}, "HOME_SCREEN");
                    openSecretPuzzleDoor(state);
                  }
                },
                child: Text(
                  APP_NAME.toUpperCase(),
                  style: CommonTextStyles.headerTextStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 70.0,
                bottom: CommonDimens.MARGIN_20,
              ),
              child: PageView(
                controller: _controller,
                physics: BouncingScrollPhysics(),
                onPageChanged: (int) {
                  sharedPreferences.setString(HOME_ROUTE_KEY, "home route");
                },
                children: <Widget>[
                  TaskPage(
                    pageNumber: 0,
                  ),
                  TaskPage(
                    pageNumber: 1,
                  ),
                  TaskPage(
                    pageNumber: 2,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 30,
                color: state.currentTheme.scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: CommonDimens.MARGIN_20,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        radius: 10,
                        dotHeight: 7,
                        dotWidth: 7,
                        activeDotColor: CommonColors.chartColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openSecretPuzzleDoor(ThemeModel appState) {
    sharedPreferences.setString(REFRESH_KEY, "secret_puzzle");
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (context) {
        _animationController.forward();
        return Container(
          height: 340,
          decoration: BoxDecoration(
            color: appState.currentTheme == lightTheme
                ? CommonColors.bottomSheetColorLightTheme
                : CommonColors.bottomSheetColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(CommonDimens.MARGIN_60 / 2),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                if (_animationController.status == AnimationStatus.forward)
                  Center(
                    child: Lottie.asset(
                      "assets/confetti_animation.json",
                      controller: _animationController,
                      repeat: true,
                    ),
                  ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Congratulations",
                        style: CommonTextStyles.loginTextStyle(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: CommonDimens.MARGIN_20,
                        ),
                        child: Text(
                          "You've unlocked the secret puzzle \n\n Now head over to Settings and open the puzzle from there",
                          style: CommonTextStyles.taskTextStyle(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: CommonDimens.MARGIN_20,
                        ),
                        child: MaterialButton(
                          color: appState.currentTheme.accentColor,
                          child: Text(
                            "Go to Settings",
                            style: CommonTextStyles.scaffoldTextStyle(context)
                                .copyWith(),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, ProfileRoute.routeName);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }
}

class HomeScreenPageControllerProvider extends ChangeNotifier {
  PageController controller;

  HomeScreenPageControllerProvider({
    this.controller,
  });

  void animateForwardBackward(int pageNumber) {
    controller.animateToPage(pageNumber,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOutCubic);
  }
}

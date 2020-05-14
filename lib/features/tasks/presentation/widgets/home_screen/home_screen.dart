import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/presentation/pages/profile_route.dart';
import 'package:project_runway/features/stats/presentation/pages/stats_screen.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_page.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "${APP_NAME}_v1_task_home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  PageController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _controller = PageController(
      initialPage: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ThemeModel>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: CommonColors.appBarColor,
        actions: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.transparent,
            child: IconButton(
                icon: Icon(
                  Icons.airplanemode_active,
                  color: state.currentTheme.accentColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, StatsScreen.routeName);
                }),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: CommonDimens.MARGIN_20),
            child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: state.currentTheme.accentColor,
                ),
                onPressed: () async {
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
            child: Text(
              APP_NAME.toUpperCase(),
              style: CommonTextStyles.headerTextStyle(context),
              textAlign: TextAlign.center,
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
                  activeDotColor: state.currentTheme.accentColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 80.0,
              bottom: CommonDimens.MARGIN_20,
            ),
            child: PageView(
              controller: _controller,
              physics: BouncingScrollPhysics(),
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
        ],
      ),
    );
  }

  void openSecretPuzzleDoor(ThemeModel appState) {
    _scaffoldKey.currentState.showBottomSheet(
      (context) => Container(
        decoration: BoxDecoration(
          color: appState.currentTheme == lightTheme
              ? CommonColors.bottomSheetColorLightTheme
              : CommonColors.bottomSheetColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Theme(
            data: ThemeData.light().copyWith(canvasColor: Colors.transparent),
            child: DraggableScrollableSheet(
              initialChildSize: 0.8,
              maxChildSize: 1.0,
              expand: false,
              builder: (_, controller) {
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}

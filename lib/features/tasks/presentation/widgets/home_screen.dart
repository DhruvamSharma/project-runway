import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/features/tasks/presentation/widgets/task_page.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "${APP_NAME}_v1_task_home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController _controller;

  @override
  void initState() {
    _controller = PageController(
      initialPage: 2,
      keepPage: true,
      viewportFraction: 0.7
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.appBarColor,
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              APP_NAME.toUpperCase(),
              style: CommonTextStyles.headerTextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: PageView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                TaskPage(),

                TaskPage(),

                TaskPage(),
              ],
            ),
          ),


          Align(
            alignment: Alignment.center,
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                APP_NAME.toUpperCase(),
                style: CommonTextStyles.rotatedDesignTextStyle(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

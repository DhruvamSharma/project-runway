import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_page.dart';

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
      initialPage: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_controller.page);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.appBarColor,
      ),
      body: GestureDetector(
        onDoubleTap: () {
          print("heello");
        },
        onLongPress: () {
          print("heello long");
        },
        child: Stack(
          children: <Widget>[
            if (_controller.page == 1.0)
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  APP_NAME.toUpperCase(),
                  style: CommonTextStyles.headerTextStyle(),
                  textAlign: TextAlign.center,
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
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
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
      ),
    );
  }

  navigateToNewActivity() {

  }
}

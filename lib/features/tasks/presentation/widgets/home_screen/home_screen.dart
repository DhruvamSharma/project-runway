import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_screen_arguments.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_page.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "${APP_NAME}_v1_task_home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: CommonColors.appBarColor,
      ),
      body: GestureDetector(
        onDoubleTap: () {
          if (_controller.page.toInt() == 0) {
            _scaffoldKey.currentState.removeCurrentSnackBar();
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                elevation: 10,
                behavior: SnackBarBehavior.floating,
                content: Text("Sorry, you can only create task for today, ie,"
                    " ${beautifyDate(buildRunningDate(
                  DateTime.now(),
                  _controller.initialPage,
                ))}."),
              ),
            );
          } else {
            try {
              navigateToNewActivity(_controller.page.toInt());
            } on Exception catch (ex) {
              // Report error
            }
          }
        },
        onLongPress: () {
          print("heello long");
        },
        child: Stack(
          children: <Widget>[
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

  navigateToNewActivity(int pageNumber) {
    Navigator.pushNamed(context, CreateTaskPage.routeName,
        arguments: CreateTaskScreenArguments(
            runningDate: buildRunningDate(DateTime.now(), pageNumber)));
  }
}

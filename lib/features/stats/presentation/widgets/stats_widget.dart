import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_snackbar.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/stats/data/models/managed_stats_model.dart';
import 'package:project_runway/features/stats/presentation/charts/task_action.dart';
import 'package:project_runway/features/stats/presentation/manager/bloc.dart';
import 'package:project_runway/features/stats/presentation/widgets/puzzle_stats_widget.dart';
import 'package:project_runway/features/stats/presentation/widgets/score_widget.dart';
import 'package:project_runway/features/stats/presentation/widgets/vision_board_stats.dart';
import 'package:project_runway/features/vision_boards/presentation/manager/bloc.dart';
import 'package:provider/provider.dart';

class StatsWidget extends StatefulWidget {
  @override
  _StatsWidgetState createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  int weeklyScore = 0;
  bool isLoading = true;
  ManagedStatsTable statsTable;
  UserEntity userEntity;
  @override
  void initState() {
    fetchStats();
    userEntity = UserModel.fromJson(
        json.decode(sharedPreferences.getString(USER_MODEL_KEY)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    return BlocListener<StatsBloc, StatsState>(
      listener: (_, state) {
        if (state is LoadedGetStatsState) {
          setState(() {
            isLoading = false;
            statsTable = state.statsTable;
            weeklyScore = statsTable.score;
          });
        }

        if (state is ErrorGetStatsState) {
          if (state.message == NO_INTERNET)
            Scaffold.of(context).showSnackBar(
              CustomSnackbar.withAnimation(
                context,
                "Sorry, you do not have a stable internet connection",
              ),
            );
          else {
            Scaffold.of(context).showSnackBar(
              CustomSnackbar.withAnimation(
                context,
                "Sorry, some error occurred",
              ),
            );
          }
          Future.delayed(Duration(seconds: 4)).then((value) => () {
                setState(() {
                  isLoading = false;
                });
              });
        }
      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CommonDimens.MARGIN_20,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: CommonDimens.MARGIN_40,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    "Total Score",
                    style: CommonTextStyles.taskTextStyle(context),
                  ),
                  ScoreWidget(weeklyScore),
                ],
              ),
            ),
          ),
          if (isLoading)
            // Load a Lottie file from your assets
            SizedBox(
                height: 300,
                child: Lottie.asset("assets/loading_stats_animation.json",
                    height: 200)),
          if (!isLoading)
            Padding(
              padding: const EdgeInsets.only(
                top: CommonDimens.MARGIN_60,
                left: CommonDimens.MARGIN_20,
                right: CommonDimens.MARGIN_20,
              ),
              child: SizedBox(
                height: 300.0,
                child: charts.BarChart(
                  buildSeries(appState),
                  animate: true,
                  defaultRenderer: charts.BarRendererConfig(
                      groupingType: charts.BarGroupingType.groupedStacked,
                      strokeWidthPx: 2.0),
                  defaultInteractions: true,
                  behaviors: [
                    new charts.SeriesLegend(
                      // Positions for "start" and "end" will be left and right respectively
                      // for widgets with a build context that has directionality ltr.
                      // For rtl, "start" and "end" will be right and left respectively.
                      // Since this example has directionality of ltr, the legend is
                      // positioned on the right side of the chart.
                      position: charts.BehaviorPosition.top,
                      // By default, if the position of the chart is on the left or right of
                      // the chart, [horizontalFirst] is set to false. This means that the
                      // legend entries will grow as new rows first instead of a new column.
                      horizontalFirst: false,
                      // This defines the padding around each legend entry.
                      cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                      // Set show measures to true to display measures in series legend,
                      // when the datum is selected.
                      showMeasures: true,
                      // Optionally provide a measure formatter to format the measure value.
                      // If none is specified the value is formatted as a decimal.
                      measureFormatter: (num value) {
                        return value == null ? '-' : '${value.toInt()}';
                      },
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(
              top: CommonDimens.MARGIN_20,
            ),
            child: Divider(
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: CommonDimens.MARGIN_20,
              bottom: CommonDimens.MARGIN_20,
            ),
            child: Text(
              "Vision Board Stats",
              style: CommonTextStyles.taskTextStyle(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(CommonDimens.MARGIN_20),
            child: Column(
              children: <Widget>[
                SizedBox(
                    height: 300,
                    child: BlocProvider<VisionBoardBloc>(
                        create: (_) => sl<VisionBoardBloc>(),
                        child: DatumLegendOptions.withSampleData())),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: CommonDimens.MARGIN_20,
            ),
            child: Divider(
              height: 1,
            ),
          ),
          if (!isLoading && userEntity.score != null && userEntity.score != 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: CommonDimens.MARGIN_20,
                      ),
                      child: Text(
                        "Puzzles Solved",
                        style: CommonTextStyles.taskTextStyle(context),
                      ),
                    ),
                    if (isLoading)
                      ScoreWidget(0)
                    else
                      ScoreWidget(userEntity.score.toInt() ~/
                          PUZZLE_ID_INCREMENT_NUMBER),
                  ],
                ),
                if (userEntity.age != null)
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: CommonDimens.MARGIN_20,
                        ),
                        child: Text(
                          "Score earned",
                          style: CommonTextStyles.taskTextStyle(context),
                        ),
                      ),
                      if (isLoading)
                        ScoreWidget(0)
                      else
                        ScoreWidget(userEntity.age),
                    ],
                  ),
              ],
            ),
          if (!isLoading && userEntity.score != null && userEntity.score != 0)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CommonDimens.MARGIN_20,
                vertical: CommonDimens.MARGIN_20,
              ),
              child: SizedBox(
                  height: 300,
                  child: PuzzleStatsWidget(
                      user: userEntity, totalScore: statsTable.score)),
            ),
        ],
      ),
    );
  }

  // build the stats chart
  List<charts.Series<TaskAction, String>> buildSeries(ThemeModel appState) {
    // create task lists
    List<TaskAction> createdTaskData = List();
    List<TaskAction> deletedTaskData = List();
    List<TaskAction> completedTaskData = List();
    if (statsTable != null) {
      // calculate current day of the week
      int currentDay = DateTime.now().weekday;
      // get the arrangement list
      List<int> arrangementList = buildDayOfTheWeekArrangementList(currentDay);
      // save the current day stats in a different field
      // So that it can be entered in to the table in
      // the end.
      // assign data to respective lists
      for (int i = 0; i < arrangementList.length; i++) {
        int dayOfTheWeek = arrangementList[i];
        createdTaskData.add(TaskAction(
            weekTranslator(dayOfTheWeek),
            statsTable.dayStats[dayOfTheWeek - 1].tasksCreated,
            CommonColors.chartColor));
//        deletedTaskData.add(TaskAction(weekTranslator(dayOfTheWeek),
//            statsTable.dayStats[dayOfTheWeek - 1].tasksDeleted, Colors.indigo));
        completedTaskData.add(TaskAction(
          weekTranslator(dayOfTheWeek),
          statsTable.dayStats[dayOfTheWeek - 1].tasksCompleted,
          CommonColors.introColor,
        ));
      }
    }
    // return 3 series
    return [
      charts.Series(
        id: 'No. of Task Completed',
        domainFn: (TaskAction clickData, _) => clickData.dayOfTheWeek,
        measureFn: (TaskAction clickData, _) => clickData.taskAmount,
        colorFn: (TaskAction clickData, _) => clickData.color,
        data: completedTaskData,
      ),
//      charts.Series(
//        id: 'No. of Tasks Deleted',
//        domainFn: (TaskAction clickData, _) => clickData.dayOfTheWeek,
//        measureFn: (TaskAction clickData, _) => clickData.taskAmount,
//        colorFn: (TaskAction clickData, _) => clickData.color,
//        data: deletedTaskData,
//      ),
      charts.Series(
        id: 'No. of Tasks Created',
        domainFn: (TaskAction clickData, _) => clickData.dayOfTheWeek,
        measureFn: (TaskAction clickData, _) => clickData.taskAmount,
        colorFn: (TaskAction clickData, _) => clickData.color,
        data: createdTaskData,
      ),
    ];
  }

  // This method arranges the days in a week so that
  // the current day always remain in the end
  List<int> buildDayOfTheWeekArrangementList(int currentDay) {
    // create an arrangement list
    List<int> arrangementList = List();
    final numberedList = List.generate(7, (index) => index + 1);
    arrangementList.addAll(numberedList.getRange(currentDay, 7));
    arrangementList.addAll(numberedList.getRange(0, currentDay));
    return arrangementList;
  }

  void fetchStats() {
    BlocProvider.of<StatsBloc>(context).add(GetStatsTableEvent());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/stats/data/models/managed_stats_model.dart';
import 'package:project_runway/features/stats/presentation/charts/task_action.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:project_runway/features/stats/presentation/manager/bloc.dart';
import 'package:project_runway/features/stats/presentation/widgets/score_widget.dart';
import 'package:provider/provider.dart';

class StatsWidget extends StatefulWidget {
  @override
  _StatsWidgetState createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  int weeklyScore = 0;
  ManagedStatsTable statsTable;
  @override
  void initState() {
    fetchStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        fetchStats();
        return;
      },
      child: BlocListener<StatsBloc, StatsState>(
        listener: (_, state) {
          if (state is LoadedGetStatsState) {
            setState(() {
              statsTable = state.statsTable;
              weeklyScore = statsTable.score;
            });
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: CommonDimens.MARGIN_20,
                ),
                child: Text(
                  "Weekly Score",
                  style: CommonTextStyles.taskTextStyle(context),
                ),
              ),
              ScoreWidget(weeklyScore),
              Padding(
                padding: const EdgeInsets.only(
                  top: CommonDimens.MARGIN_80,
                  left: CommonDimens.MARGIN_20,
                  right: CommonDimens.MARGIN_20,
                ),
                child: SizedBox(
                  height: 300.0,
                  child: charts.BarChart(
                    buildSeries(),
                    animate: true,
                    defaultRenderer: new charts.BarRendererConfig(
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
                        cellPadding:
                            new EdgeInsets.only(right: 4.0, bottom: 4.0),
                        // Set show measures to true to display measures in series legend,
                        // when the datum is selected.
                        showMeasures: true,
                        // Optionally provide a measure formatter to format the measure value.
                        // If none is specified the value is formatted as a decimal.
                        measureFormatter: (num value) {
                          return value == null ? '-' : '${value}k';
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // build the stats chart
  List<charts.Series<TaskAction, String>> buildSeries() {
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
            Colors.blueGrey));
        deletedTaskData.add(TaskAction(weekTranslator(dayOfTheWeek),
            statsTable.dayStats[dayOfTheWeek - 1].tasksDeleted, Colors.grey));
        completedTaskData.add(TaskAction(
            weekTranslator(dayOfTheWeek),
            statsTable.dayStats[dayOfTheWeek - 1].tasksCompleted,
                Provider.of<ThemeModel>(context).currentTheme.accentColor,));
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
      charts.Series(
        id: 'No. of Tasks Created',
        domainFn: (TaskAction clickData, _) => clickData.dayOfTheWeek,
        measureFn: (TaskAction clickData, _) => clickData.taskAmount,
        colorFn: (TaskAction clickData, _) => clickData.color,
        data: createdTaskData,
      ),
//      charts.Series(
//        id: 'No. of Tasks Deleted',
//        domainFn: (TaskAction clickData, _) => clickData.dayOfTheWeek,
//        measureFn: (TaskAction clickData, _) => clickData.taskAmount,
//        colorFn: (TaskAction clickData, _) => clickData.color,
//        data: deletedTaskData,
//      ),
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
    BlocProvider.of<StatsBloc>(context).dispatch(GetStatsTableEvent());
  }
}

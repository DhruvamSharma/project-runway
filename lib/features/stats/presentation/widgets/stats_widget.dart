import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/features/stats/data/models/managed_stats_model.dart';
import 'package:project_runway/features/stats/presentation/charts/task_action.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:project_runway/features/stats/presentation/manager/bloc.dart';

class StatsWidget extends StatefulWidget {
  @override
  _StatsWidgetState createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  int weeklyScore = 0;
  ManagedStatsTable statsTable;
  @override
  void initState() {
    BlocProvider.of<StatsBloc>(context).dispatch(GetStatsTableEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StatsBloc, StatsState>(
      listener: (_, state) {
        if (state is LoadedGetStatsState) {
          setState(() {
            statsTable = state.statsTable;
            weeklyScore = statsTable.score;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: CommonDimens.MARGIN_80,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              for (int i = 0; i < 1; i++)
                Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_80,
                  ),
                  child: SizedBox(
                    height: 200.0,
                    child: charts.BarChart(
                      buildSeries(),
                      animate: true,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                  top: CommonDimens.MARGIN_60,
                ),
                child: Text(
                  "Your Weekly Score: $weeklyScore",
                  style: CommonTextStyles.taskTextStyle(),
                ),
              )
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
      // assign data to respective lists
      for (int i = 0; i < statsTable.dayStats.length; i++) {
        createdTaskData.add(TaskAction(weekTranslator(i + 1),
            statsTable.dayStats[i].tasksCreated + i, Colors.indigo));
        deletedTaskData.add(TaskAction(weekTranslator(i + 1),
            statsTable.dayStats[i].tasksDeleted + 1, Colors.red));
        completedTaskData.add(TaskAction(weekTranslator(i + 1),
            statsTable.dayStats[i].tasksCompleted + i, Colors.green));
      }
    }
    // return 3 series
    return [
      charts.Series(
        id: 'series',
        domainFn: (TaskAction clickData, _) => clickData.dayOfTheWeek,
        measureFn: (TaskAction clickData, _) => clickData.taskAmount,
        colorFn: (TaskAction clickData, _) => clickData.color,
        data: createdTaskData,
      ),
    ];
  }
}

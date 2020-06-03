import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/stats/data/models/puzzle_model.dart';
import 'package:project_runway/features/stats/presentation/manager/bloc.dart';
import 'package:provider/provider.dart';

class PuzzleStatsWidget extends StatefulWidget {
  final UserEntity user;
  final int totalScore;
  PuzzleStatsWidget({
    this.user,
    this.totalScore,
  });

  @override
  _PuzzleStatsWidgetState createState() => _PuzzleStatsWidgetState();
}

class _PuzzleStatsWidgetState extends State<PuzzleStatsWidget> {
  List<UserPuzzleModel> solvedPuzzleList;
  bool isLoading = true;
  @override
  void initState() {
    BlocProvider.of<StatsBloc>(context)
        .add(GetPuzzleSolvedList(userId: widget.user.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    return BlocListener<StatsBloc, StatsState>(
      listener: (_, state) {
        setState(() {
          isLoading = false;
        });
        if (state is LoadedGetPuzzleSolvedListState) {
          solvedPuzzleList = state.puzzleSolutions;
        }

        if (state is ErrorGetPuzzleSolvedListState) {
          if (state.message == NO_INTERNET)
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                "Sorry, you do not have an internet connection",
                style: CommonTextStyles.scaffoldTextStyle(context),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: appState.currentTheme == lightTheme
                  ? CommonColors.scaffoldColor
                  : CommonColors.accentColor,
            ));
        }
      },
      child: (solvedPuzzleList != null && solvedPuzzleList.length > 3)
          ? charts.TimeSeriesChart(
              seriesList(),
              animate: true,
              // Configure the default renderer as a line renderer. This will be used
              // for any series that does not define a rendererIdKey.
              //
              // This is the default configuration, but is shown here for  illustration.
              defaultRenderer: charts.LineRendererConfig(),
              // Custom renderer configuration for the point series.
              customSeriesRenderers: [
                charts.PointRendererConfig(
                    // ID used to link series to this renderer.
                    customRendererId: 'customPoint')
              ],
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
                    return value == null ? '-' : '$value';
                  },
                ),
              ],
              // Optionally pass in a [DateTimeFactory] used by the chart. The factory
              // should create the same type of [DateTime] as the data provided. If none
              // specified, the default creates local date time.
              dateTimeFactory: const charts.LocalDateTimeFactory(),
            )
          : Center(
              child: Text(
              "Enough Data not available. Try solving 3 or more puzzles",
              textAlign: TextAlign.center,
              style: appState.currentTheme == lightTheme
                  ? CommonTextStyles.disabledTaskTextStyle().copyWith(
                      color: CommonColors.scaffoldColor,
                    )
                  : CommonTextStyles.disabledTaskTextStyle(),
            )),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<TimeSeriesSales, DateTime>> seriesList() {
    if (solvedPuzzleList == null) {
      return [];
    } else {
      List<TimeSeriesSales> puzzleCreatedDateList = List();
      List<TimeSeriesSales> puzzleSolvedDateList = List();
      for (int i = 0; i < solvedPuzzleList.length; i++) {
        final solvedModel = solvedPuzzleList[i];
        puzzleCreatedDateList.add(
            TimeSeriesSales(solvedModel.puzzleCreatedAt, solvedModel.puzzleId));
        puzzleSolvedDateList.add(TimeSeriesSales(
            solvedModel.puzzleSolvedDate, solvedModel.puzzlePointsEarned));
      }

      return [
        charts.Series<TimeSeriesSales, DateTime>(
          id: 'Puzzle Solved',
          colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.points,
          data: puzzleSolvedDateList,
        ),
        charts.Series<TimeSeriesSales, DateTime>(
          id: 'Puzzle Created',
          colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.points,
          data: puzzleCreatedDateList,
        ),
        charts.Series<TimeSeriesSales, DateTime>(
          id: '',
          colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.points,
          data: puzzleCreatedDateList,
        )
          // Configure our custom point renderer for this series.
          ..setAttribute(charts.rendererIdKey, 'customPoint'),
      ];
    }
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int points;

  TimeSeriesSales(this.time, this.points);
}

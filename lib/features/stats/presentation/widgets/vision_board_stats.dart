import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;

/// Pie chart with example of a legend with customized position, justification,
/// desired max rows, padding, and entry text styles. These options are shown as
/// an example of how to use the customizations, they do not necessary have to
/// be used together in this way. Choosing [end] as the position does not
/// require the justification to also be [endDrawArea].
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys/keys.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';
import 'package:project_runway/features/vision_boards/presentation/manager/bloc.dart';
import 'package:provider/provider.dart';

class DatumLegendOptions extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final UserModel user;

  DatumLegendOptions(this.seriesList, {this.animate})
      : user = UserModel.fromJson(
            json.decode(sharedPreferences.getString(USER_MODEL_KEY)));

  factory DatumLegendOptions.withSampleData() {
    return DatumLegendOptions(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  _DatumLegendOptionsState createState() => _DatumLegendOptionsState();

  /// Create series list with one series
  static List<charts.Series<LinearSales, String>> _createSampleData() {
    final data = [
      new LinearSales("Visions Completed", 25),
      new LinearSales("Visions Created", 75),
    ];

    return [
      new charts.Series<LinearSales, String>(
        id: 'Vision Board',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        colorFn: (LinearSales sales, _) {
          if (sales.year == "Visions Completed") {
            return charts.ColorUtil.fromDartColor(CommonColors.chartColor);
          } else {
            return charts.ColorUtil.fromDartColor(CommonColors.introColor);
          }
        },
        labelAccessorFn: (LinearSales row, _) => '${row.sales} Visions',
        data: data,
      ),
    ];
  }
}

class _DatumLegendOptionsState extends State<DatumLegendOptions> {
  List<VisionModel> visions;

  @override
  void initState() {
    BlocProvider.of<VisionBoardBloc>(context).add(
      GetAllVisionBoardsEvent(
        userId: widget.user.userId,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    return BlocListener<VisionBoardBloc, VisionBoardState>(
      listener: (_, state) {
        if (state is LoadedGetAllVisionBoardState) {
          if (state.visionBoardList.isNotEmpty) {
            BlocProvider.of<VisionBoardBloc>(context).add(
              GetAllVisionsEvent(
                visionBoardId: state.visionBoardList[0].visionBoardId,
              ),
            );
          }
        }

        if (state is LoadedGetAllVisionState) {
          if (state.visionList.isNotEmpty) {
            setState(() {
              visions = state.visionList;
            });
          } else {
            setState(() {
              visions = [];
            });
          }
        }

        if (state is ErrorVisionBoardState) {
          print("error getting vision board: ${state.message}");
          setState(() {
            visions = [];
          });
        }
      },
      child: (visions != null && visions.isNotEmpty)
          ? charts.PieChart(
              _buildSeries(visions, appState),
              animate: true,
              // Add the legend behavior to the chart to turn on legends.
              // This example shows how to change the position and justification of
              // the legend, in addition to altering the max rows and padding.
              defaultInteractions: true,
              defaultRenderer: charts.ArcRendererConfig(
                  arcWidth: 40,
                  arcRendererDecorators: [
                    charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.outside,
                      leaderLineColor: charts.ColorUtil.fromDartColor(
                          CommonColors.introColor),
                    ),
                  ]),
              behaviors: [
                charts.DatumLegend(
                  legendDefaultMeasure: charts.LegendDefaultMeasure.none,
                  desiredMaxColumns: 4,
                  // Positions for "start" and "end" will be left and right respectively
                  // for widgets with a build context that has directionality ltr.
                  // For rtl, "start" and "end" will be right and left respectively.
                  // Since this example has directionality of ltr, the legend is
                  // positioned on the right side of the chart.
                  position: charts.BehaviorPosition.top,
                  // For a legend that is positioned on the left or right of the chart,
                  // setting the justification for [endDrawArea] is aligned to the
                  // bottom of the chart draw area.
                  // By default, if the position of the chart is on the left or right of
                  // the chart, [horizontalFirst] is set to false. This means that the
                  // legend entries will grow as new rows first instead of a new column.
                  horizontalFirst: false,
                  // By setting this value to 2, the legend entries will grow up to two
                  // rows before adding a new column.
                  desiredMaxRows: 2,
                  // This defines the padding around each legend entry.
                  cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                  // Render the legend entry text with custom styles.
                  showMeasures: true,
                  measureFormatter: (num value) {
                    print(value);
                    return value == null ? '00' : '${value.toInt()}00';
                  },
                )
              ],
            )
          : Center(
              child: Text(
              "Enough Data not available. Create some visions for your Vision Board",
              textAlign: TextAlign.center,
              style: appState.currentTheme == lightTheme
                  ? CommonTextStyles.disabledTaskTextStyle().copyWith(
                      color: CommonColors.scaffoldColor,
                    )
                  : CommonTextStyles.disabledTaskTextStyle(),
            )),
    );
  }

  /// Create series list with one series
  static List<charts.Series<LinearSales, String>> _buildSeries(
      List<VisionModel> visions, ThemeModel appState) {
    if (visions != null && visions.isNotEmpty) {
      List<LinearSales> data;
      int noOfVisionsCompleted = 0;
      for (int i = 0; i < visions.length; i++) {
        if (visions[i].isCompleted) {
          noOfVisionsCompleted++;
        }
      }

      data = [
        LinearSales("Visions Completed", noOfVisionsCompleted),
        LinearSales("Visions Created", visions.length),
      ];

      return [
        new charts.Series<LinearSales, String>(
          id: 'Vision Board Stats',
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          colorFn: (LinearSales sales, _) {
            if (sales.year == "Visions Completed") {
              return charts.ColorUtil.fromDartColor(CommonColors.chartColor);
            } else {
              return charts.ColorUtil.fromDartColor(CommonColors.introColor);
            }
          },
          outsideLabelStyleAccessorFn: (LinearSales row, _) =>
              charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(
                      appState.currentTheme == lightTheme
                          ? CommonColors.scaffoldColor
                          : CommonColors.introColor)),
          labelAccessorFn: (LinearSales row, _) => '${row.sales} Visions',
          data: data,
        ),
      ];
    } else {
      return [];
    }
  }
}

/// Sample linear data type.
class LinearSales {
  final String year;
  final int sales;

  LinearSales(this.year, this.sales);
}

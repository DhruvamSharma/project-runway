import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/features/stats/presentation/charts/task_action.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:project_runway/features/stats/presentation/manager/bloc.dart';
import 'package:project_runway/features/stats/presentation/widgets/stats_widget.dart';

class StatsScreen extends StatelessWidget {
  static const String routeName = "${APP_NAME}_v1_task_stats-screen";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatsBloc>(
      builder: (_) => sl<StatsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CommonColors.appBarColor,
        ),
        body: Stack(
          children: <Widget>[
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
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Stats".toUpperCase(),
                style: CommonTextStyles.headerTextStyle(),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: CommonDimens.MARGIN_20,
              ),
              child: Center(
                child: StatsWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

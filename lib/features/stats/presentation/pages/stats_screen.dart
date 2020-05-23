import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/stats/presentation/charts/task_action.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:project_runway/features/stats/presentation/manager/bloc.dart';
import 'package:project_runway/features/stats/presentation/widgets/stats_widget.dart';
import 'package:project_runway/features/stats/presentation/widgets/user_not_verified_widget.dart';

class StatsScreen extends StatelessWidget {
  static const String routeName = "${APP_NAME}_v1_stats_stats-screen";
  final UserEntity user;

  StatsScreen()
      : user = UserModel.fromJson(
            json.decode(sharedPreferences.getString(USER_MODEL_KEY)));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatsBloc>(
      create: (_) => sl<StatsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CommonColors.appBarColor,
        ),
        body: SingleChildScrollView(
          child: Stack(
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

              if (user.isVerified)
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Stats".toUpperCase(),
                      style: CommonTextStyles.headerTextStyle(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: StatsWidget(),
                  ),
                ],
              ),

              if (!user.isVerified)
                UserNotVerifiedWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/login/presentation/manager/bloc.dart';
import 'package:project_runway/features/stats/presentation/manager/bloc.dart';
import 'package:provider/provider.dart';

class SecretPuzzleWidget extends StatefulWidget {
  static const String routeName = "${APP_NAME}_v1_user_secret-puzzle";
  final UserEntity user;

  SecretPuzzleWidget()
      : user = UserModel.fromJson(
            json.decode(sharedPreferences.getString(USER_MODEL_KEY)));

  @override
  _SecretPuzzleWidgetState createState() => _SecretPuzzleWidgetState();
}

class _SecretPuzzleWidgetState extends State<SecretPuzzleWidget> {
  String puzzleSolution;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    return BlocProvider<LoginBloc>(
      create: (_) => sl<LoginBloc>(),
      child: BlocProvider<StatsBloc>(
        create: (_) => sl<StatsBloc>(),
        child: Builder(
          builder: (blocContext) => Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Stack(
              alignment: Alignment.topCenter,
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
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: CommonDimens.MARGIN_40,
                        ),
                        child: Text(
                          "Secret".toUpperCase(),
                          style: CommonTextStyles.headerTextStyle(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      AnimatedCrossFade(
                        duration: Duration(milliseconds: 500),
                        crossFadeState:
                            (sharedPreferences.containsKey(PUZZLE_SOLVED) ||
                                    widget.user.score != null)
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                        secondChild: Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: CommonDimens.MARGIN_20,
                                  right: CommonDimens.MARGIN_20,
                                ),
                                child: Text(
                                  "Congratulations, You've won $SOLVE_PUZZLE_POINTS points,"
                                  " head over to see your updated stats",
                                  style:
                                      CommonTextStyles.taskTextStyle(context),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: CommonDimens.MARGIN_40,
                                ),
                                child: Lottie.network(
                                  "https://assets9.lottiefiles.com/private_files/lf30_P2wyYh.json",
                                  height: 200,
                                ),
                              ),
                            ],
                          ),
                        ),
                        firstChild: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: CommonDimens.MARGIN_20,
                                right: CommonDimens.MARGIN_20,
                              ),
                              child: Text(
                                "Here is your secret puzzle $SOLVE_PUZZLE_POINTS points",
                                style: CommonTextStyles.taskTextStyle(context),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: CommonDimens.MARGIN_60,
                                vertical: CommonDimens.MARGIN_20,
                              ),
                              child: CustomTextField(
                                null,
                                null,
                                isRequired: true,
                                label: "Answer",
                                type: TextInputType.number,
                                onValueChange: (text) {
                                  puzzleSolution = text;
                                },
                                textInputFormatter: [
                                  LengthLimitingTextInputFormatter(2),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                CommonDimens.MARGIN_20,
                              ),
                              child: CachedNetworkImage(
                                height: 200,
                                imageUrl: appState.currentTheme != lightTheme
                                    ? "https://imgur.com/ugK9wk9.png"
                                    : "https://imgur.com/iYd1xS1.png",
                                progressIndicatorBuilder:
                                    (_, string, progress) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: CommonDimens.MARGIN_80),
                                    child: LinearProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!sharedPreferences.containsKey(PUZZLE_SOLVED) &&
                    widget.user.score == null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: CommonDimens.MARGIN_20,
                        bottom: CommonDimens.MARGIN_20,
                      ),
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          // check for nullability
                          if (puzzleSolution != null &&
                              puzzleSolution.isNotEmpty) {
                            if (int.parse(puzzleSolution) == 29) {
                              _scaffoldKey.currentState.removeCurrentSnackBar();
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Congratulation, your answer is correct",
                                    style: CommonTextStyles.scaffoldTextStyle(
                                        context),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor:
                                      appState.currentTheme == lightTheme
                                          ? CommonColors.scaffoldColor
                                          : CommonColors.accentColor,
                                ),
                              );
                              setState(() {
                                sharedPreferences.setString(
                                    PUZZLE_SOLVED, "solved");
                                if (widget.user.score != null) {
                                  widget.user.score +=
                                      SOLVE_PUZZLE_POINTS.toDouble();
                                } else {
                                  widget.user.score =
                                      SOLVE_PUZZLE_POINTS.toDouble();
                                }
                              });

                              BlocProvider.of<StatsBloc>(blocContext).add(
                                  AddScoreEvent(score: SOLVE_PUZZLE_POINTS));
                              BlocProvider.of<LoginBloc>(blocContext)
                                  .add(LoginUserEvent(user: widget.user));
                            } else {
                              _scaffoldKey.currentState.removeCurrentSnackBar();
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Oops, wrong answer, try again",
                                    style: CommonTextStyles.scaffoldTextStyle(
                                        context),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor:
                                      appState.currentTheme == lightTheme
                                          ? CommonColors.scaffoldColor
                                          : CommonColors.accentColor,
                                ),
                              );
                            }
                          } else {
                            _scaffoldKey.currentState.removeCurrentSnackBar();
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Please enter your answer",
                                  style: CommonTextStyles.scaffoldTextStyle(
                                      context),
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor:
                                    appState.currentTheme == lightTheme
                                        ? CommonColors.scaffoldColor
                                        : CommonColors.accentColor,
                              ),
                            );
                          }
                        },
                        label: Text("Submit"),
                        icon: Icon(Icons.all_inclusive),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

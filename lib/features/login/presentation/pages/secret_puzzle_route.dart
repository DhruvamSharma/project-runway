import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:project_runway/features/stats/data/models/puzzle_model.dart';
import 'package:project_runway/features/stats/presentation/manager/bloc.dart';
import 'package:provider/provider.dart';

class SecretPuzzleRoute extends StatefulWidget {
  static const String routeName = "${APP_NAME}_v1_user_secret-puzzle";
  final UserEntity user;

  SecretPuzzleRoute()
      : user = UserModel.fromJson(
            json.decode(sharedPreferences.getString(USER_MODEL_KEY)));

  @override
  _SecretPuzzleRouteState createState() => _SecretPuzzleRouteState();
}

class _SecretPuzzleRouteState extends State<SecretPuzzleRoute> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isLoading = true;
  String puzzleSolution;
  PuzzleModel puzzle;
  @override
  void initState() {
    int puzzleId;
    // check for the nullability of score
    if (widget.user.score != null) {
      puzzleId = widget.user.score.toInt();
    } else {
      puzzleId = 0;
    }
    BlocProvider.of<StatsBloc>(context).add(GetPuzzleEvent(puzzleId: puzzleId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocListener<StatsBloc, StatsState>(
        listener: (_, state) {
          if (state is LoadedGetPuzzleState) {
            setState(() {
              isLoading = false;
            });
            puzzle = state.puzzle;
          }

          if (state is ErrorGetPuzzleState) {
            setState(() {
              isLoading = false;
            });
            print("puzzle error ${state.message}");
          }
        },
        child: Stack(
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
                  if (!isLoading && puzzle != null)
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: CommonDimens.MARGIN_20,
                            right: CommonDimens.MARGIN_20,
                          ),
                          child: Text(
                            "Here is your secret puzzle ${puzzle.puzzlePoints} points",
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
                                ? puzzle.puzzleImageLight
                                : puzzle.puzzleImageDark,
                            progressIndicatorBuilder: (_, string, progress) {
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
                ],
              ),
            ),
            if (puzzle != null)
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
                      if (puzzleSolution != null && puzzleSolution.isNotEmpty) {
                        if (int.parse(puzzleSolution) ==
                            puzzle.puzzleSolution) {
                          _scaffoldKey.currentState.removeCurrentSnackBar();
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                "Congratulation, your answer is correct",
                                style:
                                    CommonTextStyles.scaffoldTextStyle(context),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor:
                                  appState.currentTheme == lightTheme
                                      ? CommonColors.scaffoldColor
                                      : CommonColors.accentColor,
                            ),
                          );
                          setState(() {
                            if (widget.user.score != null) {
                              widget.user.score += PUZZLE_ID_INCREMENT_NUMBER;
                            } else {
                              widget.user.score =
                                  PUZZLE_ID_INCREMENT_NUMBER.toDouble();
                            }
                          });

                          // add points earned from puzzle to age param
                          if (widget.user.age == null) {
                            widget.user.age = puzzle.puzzlePoints;
                          } else {
                            widget.user.age += puzzle.puzzlePoints;
                          }
                          setPuzzleSolution();
                          BlocProvider.of<LoginBloc>(context)
                              .add(LoginUserEvent(user: widget.user));
                        } else {
                          _scaffoldKey.currentState.removeCurrentSnackBar();
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                "Oops, wrong answer, try again",
                                style:
                                    CommonTextStyles.scaffoldTextStyle(context),
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
                              style:
                                  CommonTextStyles.scaffoldTextStyle(context),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: appState.currentTheme == lightTheme
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
    );
  }

  void setPuzzleSolution() {
    final puzzleSolution = UserPuzzleModel(
      userId: widget.user.userId,
      puzzleSolvedDate: DateTime.now(),
      puzzleCreatedAt: puzzle.puzzleCreatedAt,
      puzzlePointsEarned: puzzle.puzzlePoints,
      puzzleId: puzzle.puzzleId,
    );

    BlocProvider.of<StatsBloc>(context)
        .add(SetUserPuzzleSolution(userPuzzleModel: puzzleSolution));
  }
}

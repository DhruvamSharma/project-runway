import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:project_runway/core/analytics_utils.dart';
import 'package:project_runway/core/auth_service.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/login/presentation/manager/bloc.dart';
import 'package:project_runway/features/login/presentation/manager/login_bloc_bloc.dart';
import 'package:project_runway/features/login/presentation/manager/login_bloc_event.dart';
import 'package:project_runway/features/login/presentation/pages/user_entry_route.dart';
import 'package:project_runway/features/login/presentation/widgets/app_into.dart';
import 'package:project_runway/features/login/presentation/widgets/custom_list_tile.dart';
import 'package:project_runway/features/stats/presentation/pages/stats_screen.dart';
import 'package:project_runway/features/tasks/presentation/widgets/secret_puzzle_widget.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/vision_board_list_route.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiredash/wiredash.dart';

class ProfileRoute extends StatefulWidget {
  static const String routeName = "${APP_NAME}_v1_user_profile-screen";
  final UserEntity user;
  ProfileRoute()
      : user = UserModel.fromJson(
            json.decode(sharedPreferences.getString(USER_MODEL_KEY)));

  @override
  _ProfileRouteState createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {
  bool isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    return BlocProvider<LoginBloc>(
      create: (_) => sl<LoginBloc>(),
      child: Builder(
        builder: (blocContext) => BlocListener<LoginBloc, LoginBlocState>(
          listener: (_, state) async {
            isLoading = false;

            if (state is LoadedFindBlocState) {
              state.user.isLoggedIn = false;
              BlocProvider.of<LoginBloc>(blocContext)
                  .add(LoginUserEvent(user: state.user));
            }

            if (state is ErrorFindUserBlocState) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  "Sorry, a problem occurred",
                  style: CommonTextStyles.scaffoldTextStyle(context),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: appState.currentTheme == lightTheme
                    ? CommonColors.scaffoldColor
                    : CommonColors.accentColor,
              ));
            }

            if (state is ErrorLoginBlocState) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  "Sorry, a problem occurred",
                  style: CommonTextStyles.scaffoldTextStyle(context),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: appState.currentTheme == lightTheme
                    ? CommonColors.scaffoldColor
                    : CommonColors.accentColor,
              ));
            }

            if (state is LoadedLoginBlocState) {
              // check if the user returned is logged in
              // and if not, log the user out of the app
              if (!state.user.isLoggedIn) {
                // clear local data
                await sharedPreferences.clear();
                // log out of google
                await AuthService.signOutOfGoogle();
                Navigator.pushNamedAndRemoveUntil(
                    context, UserEntryRoute.routeName, (route) => false);
              }
              // show successful message
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  "Linking account successful. Now you can use full suite of tools",
                  style: CommonTextStyles.scaffoldTextStyle(context),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: appState.currentTheme == lightTheme
                    ? CommonColors.scaffoldColor
                    : CommonColors.accentColor,
              ));
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
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
                      style: CommonTextStyles.rotatedDesignTextStyle(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "config".toUpperCase(),
                    style: CommonTextStyles.headerTextStyle(context),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_60 * 2,
                  ),
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: CommonColors.chartColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          if (!widget.user.isVerified)
                            CustomListTile(
                              leadingIcon: Icons.link,
                              onTap: () async {
                                AnalyticsUtils.sendAnalyticEvent(
                                    MORE_DETAILS, {}, "SETTING_SCREEN");
                                await AuthService.signOutOfGoogle();
                                FirebaseUser firebaseUser = await AuthService
                                    .linkAnonymousAccountWithGoogleAuth();
                                if (firebaseUser != null) {
                                  // build the UI again and hide
                                  // the Link with Google option
                                  setState(() {
                                    widget.user.isVerified = true;
                                  });
                                  // Login the user
                                  BlocProvider.of<LoginBloc>(blocContext)
                                      .add(LoginUserEvent(user: widget.user));
                                } else {
                                  // show successful message
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Linking the accounts failed. Either"
                                      " you don't have a stable internet"
                                      " connection or the account is"
                                      " already in use",
                                      style: CommonTextStyles.scaffoldTextStyle(
                                          context),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor:
                                        appState.currentTheme == lightTheme
                                            ? CommonColors.scaffoldColor
                                            : CommonColors.accentColor,
                                  ));
                                }
                              },
                              appState: appState,
                              text:
                                  "Link your Google Account to use the full suite of features",
                            ),
                          if (!widget.user.isVerified)
                            Divider(
                              color: appState.currentTheme == lightTheme
                                  ? CommonColors.dateTextColorLightTheme
                                  : CommonColors.dateTextColor,
                            ),
                          CustomListTile(
                            leadingIcon: Icons.airplanemode_active,
                            onTap: () {
                              AnalyticsUtils.sendAnalyticEvent(
                                  SEE_STATS_IN_SETTINGS, {}, "SETTING_SCREEN");
                              Navigator.pushNamed(
                                  context, StatsScreen.routeName);
                            },
                            appState: appState,
                            text: "See your weekly stats and how you perform",
                          ),
                          Divider(
                            color: appState.currentTheme == lightTheme
                                ? CommonColors.dateTextColorLightTheme
                                : CommonColors.dateTextColor,
                          ),
                          CustomListTile(
                            leadingIcon: Icons.visibility,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, VisionBoardListRoute.routeName);
                            },
                            appState: appState,
                            text: "Vision Board",
                            isNew: true,
                          ),
                          Divider(
                            color: appState.currentTheme == lightTheme
                                ? CommonColors.dateTextColorLightTheme
                                : CommonColors.dateTextColor,
                          ),
                          CustomListTile(
                            leadingIcon: Icons.lightbulb_outline,
                            onTap: () {
                              if (appState.currentTheme == lightTheme) {
                                SystemChrome.setSystemUIOverlayStyle(
                                    SystemUiOverlayStyle(
                                  statusBarColor: Colors.black87,
                                ));
                              } else {
                                SystemChrome.setSystemUIOverlayStyle(
                                    SystemUiOverlayStyle(
                                  statusBarColor: Colors.white,
                                ));
                              }
                              appState.toggleTheme();
                              AnalyticsUtils.sendAnalyticEvent(
                                  THEME_CHANGE,
                                  {
                                    "changedToTheme":
                                        appState.currentTheme == lightTheme
                                            ? "light-theme"
                                            : "dark-theme"
                                  },
                                  "SETTING_SCREEN");
                            },
                            appState: appState,
                            text: appState.currentTheme == lightTheme
                                ? "Want to use dark theme?"
                                : "Want to use light theme?",
                            trailing: Theme(
                              data: ThemeData(
                                  unselectedWidgetColor:
                                      appState.currentTheme.accentColor),
                              child: Switch.adaptive(
                                inactiveTrackColor: Colors.grey,
                                activeTrackColor: CommonColors.chartColor,
                                value: appState.currentTheme == lightTheme,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                activeColor: appState.currentTheme.accentColor,
                                onChanged: (value) {
                                  appState.toggleTheme();
                                },
                              ),
                            ),
                          ),
                          Divider(
                            color: appState.currentTheme == lightTheme
                                ? CommonColors.dateTextColorLightTheme
                                : CommonColors.dateTextColor,
                          ),
                          CustomListTile(
                            leadingIcon: Icons.bug_report,
                            onTap: () {
                              try {
                                AnalyticsUtils.sendAnalyticEvent(
                                    BUG_REPORT, {}, "SETTING_SCREEN");
                                Wiredash.of(context).show();
                              } catch (ex) {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    "Sorry, a problem occurred, try again later",
                                    style: CommonTextStyles.scaffoldTextStyle(
                                        context),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor:
                                      appState.currentTheme == lightTheme
                                          ? CommonColors.scaffoldColor
                                          : CommonColors.accentColor,
                                ));
                              }
                            },
                            appState: appState,
                            text: "Report a bug, or request a feature",
                          ),
                          Divider(
                            color: appState.currentTheme == lightTheme
                                ? CommonColors.dateTextColorLightTheme
                                : CommonColors.dateTextColor,
                          ),
                          CustomListTile(
                            leadingIcon: Icons.cached,
                            onTap: () {
                              AnalyticsUtils.sendAnalyticEvent(
                                  VIEW_APP_TUTORIAL, {}, "SETTING_SCREEN");
                              Navigator.pushNamed(
                                  context, AppIntroWidget.routeName);
                            },
                            appState: appState,
                            text: "View the app tutorial again",
                          ),
                          Divider(
                            color: appState.currentTheme == lightTheme
                                ? CommonColors.dateTextColorLightTheme
                                : CommonColors.dateTextColor,
                          ),
                          CustomListTile(
                            leadingIcon: Icons.share,
                            onTap: () {
                              AnalyticsUtils.sendAnalyticEvent(
                                  SHARE_APP, {}, "SETTING_SCREEN");
                              Share.share(
                                'Check out this great and simple To-Do app to manage productivity:\nhttps://play.google.com/store/apps/details?id=io.dhruvam.project_runway',
                                subject:
                                    'Look! A great and simple To Do app to manage productivity',
                              );
                            },
                            appState: appState,
                            text: "Share the app",
                          ),
                          if (sharedPreferences.containsKey(REFRESH_KEY) ||
                              widget.user.score != null)
                            Divider(
                              color: appState.currentTheme == lightTheme
                                  ? CommonColors.dateTextColorLightTheme
                                  : CommonColors.dateTextColor,
                            ),
                          if (sharedPreferences.containsKey(REFRESH_KEY) ||
                              widget.user.score != null)
                            CustomListTile(
                              leadingIcon: Icons.all_inclusive,
                              onTap: () {
                                double level = 0;
                                try {
                                  level = widget.user.score / 13;
                                } catch (ex) {
                                  // DO nothing
                                }
                                AnalyticsUtils.sendAnalyticEvent(
                                    READ_PUZZLE,
                                    {
                                      "userLevel": level,
                                    },
                                    "SETTING_SCREEN");
                                Navigator.pushNamed(
                                    context, SecretPuzzleWidget.routeName);
                              },
                              appState: appState,
                              text: "Read the secret puzzle",
                            ),
                          Divider(
                            color: appState.currentTheme == lightTheme
                                ? CommonColors.dateTextColorLightTheme
                                : CommonColors.dateTextColor,
                          ),
                          CustomListTile(
                            leadingIcon: Icons.info_outline,
                            onTap: () async {
                              PackageInfo packageInfo =
                                  await PackageInfo.fromPlatform();
                              showAboutDialog(
                                context: context,
                                applicationIcon: CachedNetworkImage(
                                  imageUrl: "https://imgur.com/4QhWedx.png",
                                  width: 31,
                                  height: 31,
                                ),
                                applicationVersion: packageInfo.version,
                                children: <Widget>[
                                  ListTile(
                                    title: Text("Created By: Dhruvam"),
                                  ),
                                  ListTile(
                                    onTap: () async {
                                      String mediumLink =
                                          "https://medium.com/@dhruvamsharma";
                                      if (await canLaunch(mediumLink)) {
                                        launch(mediumLink);
                                      }
                                    },
                                    title: Text("Medium Blogs"),
                                  ),
                                  ListTile(
                                    onTap: () async {
                                      String githubLink =
                                          "https://github.com/DhruvamSharma";
                                      if (await canLaunch(githubLink)) {
                                        launch(githubLink);
                                      }
                                    },
                                    title: Text("Github Account"),
                                  ),
                                  ListTile(
                                    onTap: () async {
                                      String twitterLink =
                                          "https://twitter.com/Dhruvam_Digest";
                                      if (await canLaunch(twitterLink)) {
                                        launch(twitterLink);
                                      }
                                    },
                                    title: Text("Twitter Account"),
                                  ),
                                ],
                                applicationName: packageInfo.appName,
                              );
                            },
                            appState: appState,
                            text: "About Runway",
                          ),
                          Divider(
                            color: appState.currentTheme == lightTheme
                                ? CommonColors.dateTextColorLightTheme
                                : CommonColors.dateTextColor,
                          ),
                          CustomListTile(
                            leadingIcon: Icons.exit_to_app,
                            onTap: () {
                              AnalyticsUtils.sendAnalyticEvent(
                                  LOG_OUT,
                                  {
                                    "userScore": widget.user.age,
                                  },
                                  "SETTING_SCREEN");
                              BlocProvider.of<LoginBloc>(blocContext).add(
                                  CheckIfUserExistsEvent(
                                      googleId: widget.user.googleId));
                            },
                            appState: appState,
                            text: "Log Out",
                          ),
                        ],
                      ),
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

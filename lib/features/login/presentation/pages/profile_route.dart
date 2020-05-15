import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/core/user_utility.dart';
import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/login/presentation/manager/bloc.dart';
import 'package:project_runway/features/login/presentation/manager/login_bloc_bloc.dart';
import 'package:project_runway/features/login/presentation/manager/login_bloc_event.dart';
import 'package:project_runway/features/login/presentation/pages/user_entry_route.dart';
import 'package:project_runway/features/login/presentation/widgets/app_into.dart';
import 'package:project_runway/features/stats/presentation/manager/bloc.dart';
import 'package:project_runway/features/stats/presentation/manager/stats_event.dart';
import 'package:project_runway/features/stats/presentation/pages/stats_screen.dart';
import 'package:project_runway/features/tasks/presentation/widgets/secret_puzzle_widget.dart';
import 'package:provider/provider.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    return BlocProvider<LoginBloc>(
      create: (_) => sl<LoginBloc>(),
      child: Builder(
        builder: (blocContext) => BlocListener<LoginBloc, LoginBlocState>(
          listener: (_, state) {
            isLoading = false;
            if (state is ErrorLoginBlocState) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  "Sorry, a problem occurred",
                  style: CommonTextStyles.scaffoldTextStyle(context),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: appState
                            .currentTheme ==
                        lightTheme
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
                    top: CommonDimens.MARGIN_80 * 2,
                    bottom: CommonDimens.MARGIN_80,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: CommonDimens.MARGIN_40,
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.airplanemode_active,
                              color: appState.currentTheme.accentColor,
                              size: 30,
                            ),
                            title: Text(
                              "See your weekly stats and how you perform",
                              style: CommonTextStyles.taskTextStyle(context),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, StatsScreen.routeName);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: CommonDimens.MARGIN_20,
                          ),
                          child: Divider(
                            color: appState.currentTheme == lightTheme
                                ? CommonColors.dateTextColorLightTheme
                                : CommonColors.dateTextColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: CommonDimens.MARGIN_20,
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.lightbulb_outline,
                              color: appState.currentTheme.accentColor,
                              size: 30,
                            ),
                            title: Text(
                              "Want to use light theme",
                              style: CommonTextStyles.taskTextStyle(context),
                            ),
                            trailing: Checkbox(
                              value: appState.currentTheme == lightTheme,
                              checkColor: appState.currentTheme.accentColor,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              activeColor: CommonColors.toggleableActiveColor,
                              onChanged: (value) {
                                appState.toggleTheme();
                              },
                            ),
                            onTap: () {
                              appState.refreshApp();
                              appState.toggleTheme();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: CommonDimens.MARGIN_20,
                          ),
                          child: Divider(
                            color: appState.currentTheme == lightTheme
                                ? CommonColors.dateTextColorLightTheme
                                : CommonColors.dateTextColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: CommonDimens.MARGIN_20,
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.cached,
                              color: appState.currentTheme.accentColor,
                              size: 30,
                            ),
                            title: Text(
                              "View the app tutorial again",
                              style: CommonTextStyles.taskTextStyle(context),
                            ),
                            onTap: () {
                            Navigator.pushNamed(context, AppIntroWidget.routeName);
                            },
                          ),
                        ),
                        if (sharedPreferences.containsKey(REFRESH_KEY))
                          Padding(
                            padding: const EdgeInsets.only(
                              top: CommonDimens.MARGIN_20,
                            ),
                            child: Divider(
                              color: appState.currentTheme == lightTheme
                                  ? CommonColors.dateTextColorLightTheme
                                  : CommonColors.dateTextColor,
                            ),
                          ),
                        if (sharedPreferences.containsKey(REFRESH_KEY))
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: CommonDimens.MARGIN_20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: CommonDimens.MARGIN_20 - 4,
                                  ),
                                  color: appState.currentTheme.accentColor,
                                  padding: const EdgeInsets.all(
                                    CommonDimens.MARGIN_20 / 8,
                                  ),
                                  child: Text(
                                    "Secret Puzzle",
                                    style: CommonTextStyles.badgeTextStyle(
                                        context),
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.all_inclusive,
                                    color: appState.currentTheme.accentColor,
                                    size: 30,
                                  ),
                                  title: Text(
                                    "Read the secret again",
                                    style:
                                        CommonTextStyles.taskTextStyle(context),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, SecretPuzzleWidget.routeName);
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CommonDimens.MARGIN_20,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: OutlineButton(
                      child: Text(
                        "Sign out",
                        style: CommonTextStyles.taskTextStyle(context),
                      ),
                      onPressed: () async {
                        // clear local data
                        await sharedPreferences.clear();
                        // log out of google
                        signOutOfGoogle();
                        // pop the profile route
                        Navigator.pop(context);
                        // pop the home route
                        Navigator.pop(context);
                        Navigator.pushNamed(context, UserEntryRoute.routeName);
                      },
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

  Future<FirebaseUser> signInWithGoogle(BuildContext context) async {
    // show the sign in dialogBox
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication;
    if (googleSignInAccount != null) {
      googleSignInAuthentication = await googleSignInAccount.authentication;
    } else {
      return null;
    }

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser firebaseUser = authResult.user;

    assert(!firebaseUser.isAnonymous);
    assert(await firebaseUser.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(firebaseUser.uid == currentUser.uid);

    return firebaseUser;
  }

  void signOutOfGoogle() async {
    await _googleSignIn.signOut();
  }
}

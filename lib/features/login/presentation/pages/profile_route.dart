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
import 'package:project_runway/features/stats/presentation/manager/bloc.dart';
import 'package:project_runway/features/stats/presentation/manager/stats_event.dart';
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
    return BlocProvider<LoginBloc>(
      builder: (_) => sl<LoginBloc>(),
      child: Builder(
        builder: (blocContext) => BlocListener<LoginBloc, LoginBlocState>(
          listener: (_, state) {
            isLoading = false;
            if (state is ErrorLoginBlocState) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Sorry, some error occurred"),
                behavior: SnackBarBehavior.floating,
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
                    "profile".toUpperCase(),
                    style: CommonTextStyles.headerTextStyle(context),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_80 * 2,
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: CommonDimens.MARGIN_40,
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.notifications_active,
                            color: Provider.of<ThemeModel>(context)
                                .currentTheme
                                .accentColor,
                            size: 30,
                          ),
                          title: Text(
                            "When do you want to receive notifications?",
                            style: CommonTextStyles.taskTextStyle(context),
                          ),
                          onTap: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: CommonDimens.MARGIN_20,
                        ),
                        child: Divider(
                          color:
                              Provider.of<ThemeModel>(context).currentTheme ==
                                      lightTheme
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
                            color: Provider.of<ThemeModel>(context)
                                .currentTheme
                                .accentColor,
                            size: 30,
                          ),
                          title: Text(
                            "Want to use light theme",
                            style: CommonTextStyles.taskTextStyle(context),
                          ),
                          trailing: Checkbox(
                            value: Provider.of<ThemeModel>(context)
                                    .currentTheme ==
                                lightTheme,
                            checkColor: Provider.of<ThemeModel>(context)
                                .currentTheme
                                .accentColor,
                            materialTapTargetSize:
                                MaterialTapTargetSize.padded,
                            activeColor: CommonColors.toggleableActiveColor,
                            onChanged: (value) {
                              Provider.of<ThemeModel>(context).toggleTheme();
                            },
                          ),
                          onTap: () {
                            Provider.of<ThemeModel>(context).toggleTheme();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: CommonDimens.MARGIN_40,
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
                        Navigator.pushNamed(
                            context, UserEntryRoute.routeName);
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

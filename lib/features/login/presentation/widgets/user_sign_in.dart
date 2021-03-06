import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/analytics_utils.dart';
import 'package:project_runway/core/auth_service.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_snackbar.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys/keys.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/presentation/manager/bloc.dart';
import 'package:project_runway/features/login/presentation/pages/user_entry_route.dart';
import 'package:provider/provider.dart';

class UserSignInWidget extends StatefulWidget {
  @override
  _UserSignInWidgetState createState() => _UserSignInWidgetState();
}

class _UserSignInWidgetState extends State<UserSignInWidget> {
  bool isFindingUser = false;
  bool isSigningInAnonymously = false;
  bool isSigningInWihGoogle = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    final userEntryState =
        Provider.of<UserEntryProviderHolder>(context, listen: false);
    return BlocProvider<LoginBloc>(
      create: (_) => sl<LoginBloc>(),
      child: Builder(
        builder: (blocContext) => Padding(
          padding: const EdgeInsets.all(
            CommonDimens.MARGIN_20,
          ),
          child: BlocListener<LoginBloc, LoginBlocState>(
            listener: (_, state) {
              setState(() {
                isFindingUser = false;
              });
              if (state is ErrorFindUserBlocState) {
                userEntryState.isNewUser = true;
                userEntryState.animatedToNextPage();
              }

              if (state is LoadedFindBlocState) {
                if (state.user != null && !state.user.isDeleted) {
                  userEntryState.disableForwardButton(false);
                  // save the user id if the user is not new
                  sharedPreferences.setString(USER_KEY, state.user.userId);
                  userEntryState.isNewUser = false;
                  userEntryState.age = state.user.age;
                  userEntryState.createdDate = state.user.createdAt;
                  userEntryState.userId = state.user.userId;
                  userEntryState.score = state.user.score;
                }
                userEntryState.animatedToNextPage();
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  buildText(context, userEntryState).toUpperCase(),
                  style: CommonTextStyles.taskTextStyle(context),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_60,
                  ),
                ),
                if (!isSigningInAnonymously)
                  buildSignInButton(
                    blocContext,
                    appState,
                    userEntryState,
                  ),
                if (isFindingUser)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CommonDimens.MARGIN_20,
                    ),
                    child: Theme(
                      data: ThemeData.dark().copyWith(
                        accentColor: CommonColors.chartColor,
                      ),
                      child: LinearProgressIndicator(
                        backgroundColor: appState.currentTheme.accentColor,
                      ),
                    ),
                  ),
                if (!isSigningInWihGoogle)
                  Padding(
                    padding: const EdgeInsets.all(
                      CommonDimens.MARGIN_20 / 2,
                    ),
                    child: Tooltip(
                      message: "Skip the sign up process",
                      child: FlatButton(
                          onPressed: () async {
                            // start showing a loader
                            setState(() {
                              isSigningInAnonymously = true;
                            });
                            AnalyticsUtils.sendAnalyticEvent(SIGN_IN,
                                {"signIn": "ANONYMOUS"}, "SIGN_UP_USER");
                            // login the user anonymously so that the
                            // user can still user firebase products
                            final firebaseUser =
                                await AuthService.signInAnonymously();
                            if (firebaseUser != null) {
                              userEntryState.disableForwardButton(false);
                              userEntryState.googleId = firebaseUser.uid;
                              userEntryState.isVerified = false;

                              userEntryState.animatedToNextPage();
                            } else {
                              Scaffold.of(context).showSnackBar(
                                CustomSnackbar.withAnimation(
                                  context,
                                  "Sorry, a problem occurred, please try again",
                                ),
                              );
                            }
                            // stop showing a loader
                            setState(() {
                              isSigningInAnonymously = false;
                            });
                          },
                          child: Text("Skip",
                              style: CommonTextStyles.taskTextStyle(context))),
                    ),
                  ),
                if (isSigningInAnonymously)
                  Padding(
                    padding: const EdgeInsets.all(CommonDimens.MARGIN_40),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: CommonDimens.MARGIN_20,
                        ),
                        child: Theme(
                          data: ThemeData.dark().copyWith(
                            accentColor: CommonColors.chartColor,
                          ),
                          child: LinearProgressIndicator(
                            backgroundColor: appState.currentTheme.accentColor,
                          ),
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

  String buildText(
      BuildContext blocContext, UserEntryProviderHolder userEntryState) {
    String initialText = "Hey,";
    if (userEntryState.isVerified) {
      return "$initialText your progress will be saved";
    } else {
      return "$initialText let's sign in to save our progress?";
    }
  }

  Widget buildSignInButton(BuildContext blocContext, ThemeModel appState,
      UserEntryProviderHolder userEntryState) {
    return Tooltip(
      message: "Sign in",
      child: AnimatedCrossFade(
        firstChild: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CommonDimens.MARGIN_20,
          ),
          child: Material(
            color: CommonColors.chartColor,
            borderRadius: BorderRadius.circular(5),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: null,
              child: Container(
                padding: const EdgeInsets.only(
                  top: CommonDimens.MARGIN_20 / 2,
                  bottom: CommonDimens.MARGIN_20 / 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/google-logo-png-open-2000.png",
                      height: 20,
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: CommonDimens.MARGIN_20,
                      ),
                      child: Text(
                        "Signed in with Google",
                        style:
                            CommonTextStyles.badgeTextStyle(context).copyWith(
                          color: CommonColors.accentColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        secondChild: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CommonDimens.MARGIN_20,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () async {
                setState(() {
                  isFindingUser = true;
                  isSigningInWihGoogle = true;
                });
                AnalyticsUtils.sendAnalyticEvent(
                    SIGN_IN,
                    {
                      "signIn": "GOOGLE",
                    },
                    "SIGN_UP_USER");
                await AuthService.signOutOfGoogle();
                final firebaseUser = await AuthService.signInWithGoogle();
                if (firebaseUser != null) {
                  userEntryState.disableForwardButton(true);
                  userEntryState.userPhotoUrl = firebaseUser.photoUrl;
                  userEntryState.googleId = firebaseUser.uid;
                  userEntryState.emailId = firebaseUser.email;
                  userEntryState.isVerified = true;
                  BlocProvider.of<LoginBloc>(blocContext)
                      .add(CheckIfUserExistsEvent(googleId: firebaseUser.uid));
                } else {
                  Scaffold.of(context).showSnackBar(
                    CustomSnackbar.withAnimation(
                      context,
                      "Sorry, a problem occurred, please try again",
                    ),
                  );
                  setState(() {
                    isFindingUser = false;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    width: 1.0,
                    color: CommonColors.disabledTaskTextColor,
                  ),
                ),
                padding: const EdgeInsets.all(
                  CommonDimens.MARGIN_20 / 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/google-logo-png-open-2000.png",
                      height: 20,
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: CommonDimens.MARGIN_20,
                      ),
                      child: Text(
                        "Sign in with Google",
                        style:
                            CommonTextStyles.badgeTextStyle(context).copyWith(
                          color: appState.currentTheme.accentColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        crossFadeState: userEntryState.isVerified
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: Duration(
          milliseconds: 300,
        ),
      ),
    );
  }
}

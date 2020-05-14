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
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/presentation/manager/bloc.dart';
import 'package:project_runway/features/login/presentation/pages/user_entry_route.dart';
import 'package:provider/provider.dart';

class UserSignInWidget extends StatefulWidget {
  @override
  _UserSignInWidgetState createState() => _UserSignInWidgetState();
}

class _UserSignInWidgetState extends State<UserSignInWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isFindingUser = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      builder: (_) => sl<LoginBloc>(),
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
              Provider.of<UserEntryProviderHolder>(blocContext)
                  .disableForwardButton(false);
              if (state is ErrorFindUserBlocState) {
                Provider.of<UserEntryProviderHolder>(context).isNewUser = true;
              }

              if (state is LoadedFindBlocState &&
                  state.user != null &&
                  !state.user.isDeleted) {
                // save the user id if the user is not new
                sharedPreferences.setString(USER_KEY, state.user.userId);
                Provider.of<UserEntryProviderHolder>(context).isNewUser = false;
                Provider.of<UserEntryProviderHolder>(context).createdDate =
                    state.user.createdAt;
                Provider.of<UserEntryProviderHolder>(context).userId =
                    state.user.userId;
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  buildText(context).toUpperCase(),
                  style: CommonTextStyles.taskTextStyle(context),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_60,
                  ),
                  child: buildSignInButton(blocContext),
                ),
                if (isFindingUser)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CommonDimens.MARGIN_20,
                    ),
                    child: LinearProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String buildText(BuildContext blocContext) {
    String initialText =
        "Hey ${Provider.of<UserEntryProviderHolder>(blocContext).userName},";
    if (Provider.of<UserEntryProviderHolder>(blocContext).isVerified) {
      return "$initialText your progress will be saved";
    } else {
      return "$initialText want to save your progress?";
    }
  }

  Widget buildSignInButton(BuildContext blocContext) {
    return AnimatedCrossFade(
      firstChild: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CommonDimens.MARGIN_20,
        ),
        child: Material(
          color: Provider.of<ThemeModel>(context).currentTheme.accentColor,
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: null,
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
                      "Signed in with Google",
                      style: CommonTextStyles.badgeTextStyle(context).copyWith(
                        color: Provider.of<ThemeModel>(context)
                            .currentTheme
                            .scaffoldBackgroundColor,
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
      secondChild: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            setState(() {
              isFindingUser = true;
            });
            final firebaseUser = await signInWithGoogle(blocContext);
            if (firebaseUser != null) {
              Provider.of<UserEntryProviderHolder>(blocContext)
                  .assignSkipButtonVisibility(false);
              Provider.of<UserEntryProviderHolder>(blocContext)
                  .disableForwardButton(true);
              Provider.of<UserEntryProviderHolder>(blocContext).userPhotoUrl =
                  firebaseUser.photoUrl;
              Provider.of<UserEntryProviderHolder>(blocContext).googleId =
                  firebaseUser.uid;
              Provider.of<UserEntryProviderHolder>(blocContext).emailId =
                  firebaseUser.email;
              Provider.of<UserEntryProviderHolder>(blocContext).isVerified =
                  true;
              BlocProvider.of<LoginBloc>(blocContext)
                  .dispatch(CheckIfUserExistsEvent(googleId: firebaseUser.uid));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Some error occurred, please try again"),
                behavior: SnackBarBehavior.floating,
              ));
              setState(() {
                isFindingUser = false;
              });
              Provider.of<UserEntryProviderHolder>(blocContext)
                  .assignSkipButtonVisibility(true);
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
            margin: const EdgeInsets.symmetric(
              horizontal: CommonDimens.MARGIN_20,
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
                    style: CommonTextStyles.badgeTextStyle(context).copyWith(
                      color: Provider.of<ThemeModel>(context)
                          .currentTheme
                          .accentColor,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      crossFadeState:
          Provider.of<UserEntryProviderHolder>(blocContext).isVerified
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
      duration: Duration(
        milliseconds: 300,
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

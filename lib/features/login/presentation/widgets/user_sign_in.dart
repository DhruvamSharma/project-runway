import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/features/login/presentation/pages/user_entry_route.dart';
import 'package:provider/provider.dart';

class UserSignInWidget extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        CommonDimens.MARGIN_20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            buildText(context).toUpperCase(),
            style: CommonTextStyles.taskTextStyle(),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: CommonDimens.MARGIN_60,
            ),
            child: buildSignInButton(context),
          ),
        ],
      ),
    );
  }

  String buildText(BuildContext context) {
    String initialText = "Hey ${Provider.of<UserEntryProviderHolder>(context).userName},";
    if (Provider.of<UserEntryProviderHolder>(context).isVerified) {
      return "$initialText your progress will be saved";
    } else {
      return "$initialText want to save your progress?";
    }
  }

  Widget buildSignInButton(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CommonDimens.MARGIN_20,
        ),
        child: Material(
          color: CommonColors.accentColor,
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
                      style: CommonTextStyles.badgeTextStyle().copyWith(
                        color: CommonColors.scaffoldColor,
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
            final firebaseUser = await signInWithGoogle(context);
            if (firebaseUser != null) {
              Provider.of<UserEntryProviderHolder>(context)
                  .assignSkipButtonVisibility(false);
              Provider.of<UserEntryProviderHolder>(context).userPhotoUrl =
                  firebaseUser.photoUrl;
              Provider.of<UserEntryProviderHolder>(context).userId =
                  firebaseUser.uid;
              Provider.of<UserEntryProviderHolder>(context).emailId =
                  firebaseUser.email;
              Provider.of<UserEntryProviderHolder>(context).isVerified = true;
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
                    style: CommonTextStyles.badgeTextStyle().copyWith(
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
      crossFadeState: Provider.of<UserEntryProviderHolder>(context).isVerified
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
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

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

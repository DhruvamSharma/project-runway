import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<FirebaseUser> signInWithGoogle() async {
    try {
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
      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser firebaseUser = authResult.user;

      assert(!firebaseUser.isAnonymous);
      assert(await firebaseUser.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(firebaseUser.uid == currentUser.uid);

      return firebaseUser;
    } catch (ex) {
      return null;
    }
  }

  static Future<FirebaseUser> linkAnonymousAccountWithGoogleAuth() async {
    try {
      // show the sign in dialogBox
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication;
      if (googleSignInAccount != null) {
        googleSignInAuthentication = await googleSignInAccount.authentication;
      } else {
        return null;
      }

      FirebaseUser currentUser = await _auth.currentUser();

      var credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken, accessToken: null);
      AuthResult authResult = await currentUser.linkWithCredential(credential);
      FirebaseUser firebaseUser = authResult.user;
      assert(firebaseUser.uid == currentUser.uid);
      return firebaseUser;
    } catch (ex) {
      return null;
    }
  }

  static Future<void> signOutOfGoogle() async {
    await _googleSignIn.signOut();
  }

  static Future<FirebaseUser> signInAnonymously() async {
    try {
      AuthResult authResult = await _auth.signInAnonymously();
      FirebaseUser firebaseUser = authResult.user;
      print(firebaseUser.uid);
      return firebaseUser;
    } catch (ex) {
      return null;
    }
  }
}

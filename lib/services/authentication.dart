import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hockey_organizer/app_localization.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;

  AuthenticationService(this._firebaseAuth, this._googleSignIn, this._facebookLogin);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  //sign in with email & password
  Future<String> signIn(BuildContext context, {String email, String password}) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return '';
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        return appLocalizations.translate('account_does_not_exists');
      } else if (error.code == 'wrong-password') {
        return appLocalizations.translate('wrong_password');
      } else {
        return '';
      }
    }
  }

  //register with email & password
  Future<String> signUp(BuildContext context,
      {String displayName, String email, String password}) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user.updateProfile(displayName: displayName);
      await userCredential.user.reload();

      try {
        await userCredential.user.sendEmailVerification();
        return '';
      } catch (e) {
        return e.message;
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        return appLocalizations.translate('account_already_exists');
      } else {
        return '';
      }
    }
  }

  //google sign in
  Future<String> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      try {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential googleCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        await _firebaseAuth.signInWithCredential(googleCredential);
      } catch (error) {
        return error.message;
      }
    }
    return '';
  }

  //facebook sign in
  Future<String> signInWithFacebook() async {
    final loginResult = await _facebookLogin.logIn(['email', 'public_profile']);

    switch (loginResult.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken.token);
        await _firebaseAuth.signInWithCredential(facebookAuthCredential);
        return '';
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        print('any error occurred');
        break;
    }
    return '';
  }

  //reset password
  Future<void> sendResetPasswordEmail(String email) async =>
      await _firebaseAuth.sendPasswordResetEmail(email: email);

  //sign out
  Future<void> signOut(User firebaseUser) async {
    if (_firebaseAuth.currentUser.providerData[0].providerId == 'google.com') {
      await _googleSignIn.signOut();
    }
    if (_firebaseAuth.currentUser.providerData[0].providerId == 'facebook.com') {
      await _facebookLogin.logOut();
      firebaseUser = null;
    }
    await _firebaseAuth.signOut();
  }

  //reload user
  Future<void> checkIfUsersEmailIsVerified() async => await _firebaseAuth.currentUser.reload();
}

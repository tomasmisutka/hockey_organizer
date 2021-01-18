import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hockey_organizer/app_localization.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  Stream<User> get userChanges => _firebaseAuth.userChanges();

  //sign in with email & password
  Future<String> signIn(BuildContext context, {String email = '', String password = ''}) async {
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
    } catch (e) {
      return e;
    }
  }

  //register with email & password
  Future<String> signUp(BuildContext context,
      {String displayName = '', String email = '', String password = ''}) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser.updateProfile(displayName: displayName);
      try {
        await _firebaseAuth.currentUser.sendEmailVerification();
        return '';
      } catch (error) {
        return error.toString();
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

    try {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential googleCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      await _firebaseAuth.signInWithCredential(googleCredential);
    } on FirebaseAuthException catch (error) {
      return error.message;
    } catch (error) {
      return error;
    }
    return '';
  }

  //facebook sign in
  Future<String> signInWithFacebook() async {
    final loginResult = await _facebookLogin.logIn(['email', 'public_profile']);

    switch (loginResult.status) {
      case FacebookLoginStatus.loggedIn:
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken.token);
        try {
          await _firebaseAuth.signInWithCredential(facebookAuthCredential);
        } on FirebaseAuthException catch (error) {
          if (error.code == 'account-exists-with-different-credential') {
            String email = error.email;
            AuthCredential pendingCredential = error.credential;
            List<String> userSignInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);

            if (userSignInMethods.first == 'google.com') {
              //sign in with google to link that emails
              GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
              GoogleSignInAuthentication googleSignInAuthentication =
                  await googleSignInAccount.authentication;
              OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
                accessToken: googleSignInAuthentication.accessToken,
                idToken: googleSignInAuthentication.idToken,
              );
              // Sign the user in with the credential
              UserCredential userCredential =
                  await _firebaseAuth.signInWithCredential(googleAuthCredential);
              // Link the pending credential with the existing account
              await userCredential.user.linkWithCredential(pendingCredential);
            } else {
              print('can not link these providers');
            }
          }
        }

        return '';
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
    return '';
  }

  //reset password
  Future<void> sendResetPasswordEmail(String email) async =>
      await _firebaseAuth.sendPasswordResetEmail(email: email);

  //sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

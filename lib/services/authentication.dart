import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hockey_organizer/app_localization.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

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

  //reset password
  Future<void> sendResetPasswordEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  //sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> checkIfUsersEmailIsVerified() async {
    await _firebaseAuth.currentUser.reload();
  }
}

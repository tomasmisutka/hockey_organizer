import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  //sign in with email & password
  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return 'Signed in';
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  //register with email & password
  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return 'Signed up';
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  //sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/services/authentication.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  final User firebaseUser;

  Dashboard(this.firebaseUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Home screen for user: ' + firebaseUser.displayName.toString(),
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 15),
              RaisedButton(
                color: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                },
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

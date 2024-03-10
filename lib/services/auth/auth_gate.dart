import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/services/auth/auth_page.dart';
import 'package:minimal_chat_app/pages/home_page.dart';
import 'package:minimal_chat_app/pages/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user logged in
          if (snapshot.hasData) {
            return HomePage();
          }

          // user NOT logged in
          else {
            return AuthPage();
          }
        },
      ),
    );
  }
}

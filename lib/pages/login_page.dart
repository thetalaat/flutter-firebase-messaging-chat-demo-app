import 'package:flutter/material.dart';
import 'package:minimal_chat_app/auth/auth_service.dart';
import 'package:minimal_chat_app/components/custom_textfield.dart';
import 'package:minimal_chat_app/components/cutom_button.dart';
import 'package:minimal_chat_app/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  // textfields controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final void Function() togglePages;

  LoginPage({super.key, required this.togglePages});

  // login method
  void login(BuildContext context) async {
    // auth service
    final authService = AuthService();

    // try login
    try {
      await authService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
    }

    // catch errors
    catch (e) {
      context.mounted
          ? showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(e.toString()),
                );
              },
            )
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50),

            // welcome back
            Text(
              "Welcome back, you've been missed!",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),

            const SizedBox(height: 25),

            // email textfield

            CustomTextField(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),

            // password text field
            CustomTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordController,
            ),

            const SizedBox(height: 25),

            // login button
            CustomButton(
              onTap: () => login(context),
              text: 'Login',
            ),

            const SizedBox(height: 25),

            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(4.0),
                  onTap: togglePages,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      "Register now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

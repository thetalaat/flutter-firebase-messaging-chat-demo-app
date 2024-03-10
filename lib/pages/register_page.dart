import 'package:flutter/material.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';
import 'package:minimal_chat_app/components/custom_textfield.dart';
import 'package:minimal_chat_app/components/cutom_button.dart';
import 'package:minimal_chat_app/pages/login_page.dart';

class RegisterPage extends StatelessWidget {
  // textfields controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final void Function() togglePages;

  RegisterPage({super.key, required this.togglePages});

  // register method
  void register(BuildContext context) async {
    // auth service
    final authService = AuthService();

    // passwords match -> create user
    if (_passwordController.text == _passwordConfirmController.text) {
      // try register
      try {
        await authService.signUpWithEmailAndPassword(
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

    // passwords Dont match -> show error
    else {
      context.mounted
          ? showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Passwords don't match!"),
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
              "Lets create an account for you",
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

            const SizedBox(height: 10),

            CustomTextField(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _passwordConfirmController,
            ),

            const SizedBox(height: 25),

            // login button
            CustomButton(
              onTap: () => register(context),
              text: 'Register',
            ),

            const SizedBox(height: 25),

            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(4.0),
                  onTap: togglePages,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      "Login",
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

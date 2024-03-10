import 'package:flutter/material.dart';
import 'package:minimal_chat_app/auth/auth_service.dart';
import 'package:minimal_chat_app/pages/settings_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void logout() {
    // auth service
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // logo
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 50.0).copyWith(top: 100),
            child: Center(
              child: Icon(
                Icons.message,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
            ),
          ),

          // home
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              iconColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.primary,
              title: const Text(
                ' H O M E',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          // settings
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              iconColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.primary,
              title: const Text(
                ' S E T T I N G S',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return SettingsPage();
                  },
                ));
              },
            ),
          ),

          const Spacer(),

          // logout
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              iconColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.primary,
              title: const Text(
                ' L O G O U T',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}

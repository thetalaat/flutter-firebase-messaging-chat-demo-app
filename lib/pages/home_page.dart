import 'package:flutter/material.dart';

import 'package:minimal_chat_app/components/custom_drawer.dart';
import 'package:minimal_chat_app/components/userTile.dart';
import 'package:minimal_chat_app/pages/chat_page.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';
import 'package:minimal_chat_app/services/chat/chat_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const CustomDrawer(),
      body: _buildUserList(),
    );
  }

  // build a list of users excet for the current user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) return const Text('Error');

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // listview
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListTile(userData, context))
              .toList(),
        );
      },
    );
  }

  // build user tile
  Widget _buildUserListTile(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
          text: userData['email'],
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ChatPage(
                  receiverEmail: userData['email'],
                  receiverID: userData['uid'],
                );
              },
            ));
          });
    } else {
      return const SizedBox();
    }
  }
}

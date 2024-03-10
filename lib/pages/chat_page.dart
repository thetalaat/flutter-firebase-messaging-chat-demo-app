import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/components/chat_bubble.dart';
import 'package:minimal_chat_app/components/custom_textfield.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';
import 'package:minimal_chat_app/services/chat/chat_service.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});
  // textfields controllers
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // send message method
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverID, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          // all messages
          Expanded(child: _buildMessageList()),

          const SizedBox(
            height: 25,
          ),

          // user input
          _buildUserInput(),

          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  // build a list of all messages
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderID, receiverID),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) return const Text('Error');

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        // listview
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildMessageListTile(doc))
              .toList(),
        );
      },
    );
  }

  // build message tile
  Widget _buildMessageListTile(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user align messages to the right
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: ChatBubble(
          isCurrentUser: isCurrentUser,
          message: data['message'],
        ));
  }

  // build user input
  Widget _buildUserInput() {
    return Row(
      children: [
        // text field
        Expanded(
            child: CustomTextField(
                hintText: 'messages',
                obscureText: false,
                controller: _messageController)),

        // send button
        Container(
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(25)),
          margin: EdgeInsets.only(right: 25.0),
          child: Center(
            child: IconButton(
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
              onPressed: sendMessage,
            ),
          ),
        ),
      ],
    );
  }
}

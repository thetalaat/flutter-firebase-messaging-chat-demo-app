import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/components/chat_bubble.dart';
import 'package:minimal_chat_app/components/custom_textfield.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';
import 'package:minimal_chat_app/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // textfields controller
  final TextEditingController _messageController = TextEditingController();

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // textfiled focus node
  FocusNode _focusNode = FocusNode();

  // scroll down method
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  // send message method
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    _focusNode.addListener(
      () {
        if (_focusNode.hasFocus) {
          // wait for keyboard to show up
          // calculate remaining screen space
          // scroll
          Future.delayed(
            const Duration(milliseconds: 200),
            () {
              return scrollDown();
            },
          );
        }
      },
    );
    // initial scroll
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        return scrollDown();
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
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
      stream: _chatService.getMessages(senderID, widget.receiverID),
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
          controller: _scrollController,
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
                focusNode: _focusNode,
                hintText: 'messages',
                obscureText: false,
                controller: _messageController)),

        // send button
        Container(
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(25)),
          margin: const EdgeInsets.only(right: 25.0),
          child: Center(
            child: IconButton(
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
              onPressed: () {
                sendMessage();
                Future.delayed(
                  const Duration(milliseconds: 200),
                  () {
                    return scrollDown();
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

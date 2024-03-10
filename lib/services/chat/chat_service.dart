import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minimal_chat_app/models/message.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';

class ChatService {
  // get firestore instance & auth service
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // get users stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore
        .collection('/DemoApps/ChatApp/Users')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    // get current user info
    final String currentUserID = _authService.getCurrentUser()!.uid;
    final String currentUserEmail = _authService.getCurrentUser()!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // create / open chat room
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // ensure that the chatRoomID is the same for any 2 people
    String chatRoomId = ids.join('_');
    await _firestore
        .collection('/DemoApps/ChatApp/ChatRooms')
        .doc(chatRoomId)
        .collection('Messages')
        .add(newMessage.toMap());

    // add new message
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // create / open chat room
    List<String> ids = [userID, otherUserID];
    ids.sort(); // ensure that the chatRoomID is the same for any 2 people
    String chatRoomId = ids.join('_');

    return _firestore
        .collection('/DemoApps/ChatApp/ChatRooms')
        .doc(chatRoomId)
        .collection('Messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

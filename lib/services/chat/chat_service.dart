import 'package:cloud_firestore/cloud_firestore.dart';
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

  // get messages
}

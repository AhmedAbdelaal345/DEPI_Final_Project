import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import '../models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get chat room reference
  DocumentReference _getChatRoomRef(String chatRoomId) {
    return _firestore.collection(AppConstants.chatRoom).doc(chatRoomId);
  }

  // Listen to messages in real-time
  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    return _getChatRoomRef(chatRoomId)
        .collection(AppConstants.messagesCollection)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromDocument(doc))
          .toList();
    });
  }

  // Send a new message
  Future<void> sendMessage({
    required String chatRoomId,
    required String text,
    required String senderId,
    required String studentId,
    required String teacherId,
    required String quizId,
  }) async {
    final chatRoomRef = _getChatRoomRef(chatRoomId);
    final timestamp = FieldValue.serverTimestamp();

    // Create the message
    final message = {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };

    // Add message to sub-collection
    await chatRoomRef.collection(AppConstants.messagesCollection).add(message);

    // Update chat room metadata (create if doesn't exist)
    await chatRoomRef.set({
      'studentId': studentId,
      'teacherId': teacherId,
      'quizId': quizId,
      'lastMessage': text,
      'lastMessageTimestamp': timestamp,
      'participants': [studentId, teacherId],
    }, SetOptions(merge: true));
  }

  // Check if chat room exists
  Future<bool> chatRoomExists(String chatRoomId) async {
    final doc = await _getChatRoomRef(chatRoomId).get();
    return doc.exists;
  }

  // Create initial chat room
  Future<void> createChatRoom({
    required String chatRoomId,
    required String studentId,
    required String teacherId,
    required String quizId,
  }) async {
    await _getChatRoomRef(chatRoomId).set({
      'studentId': studentId,
      'teacherId': teacherId,
      'quizId': quizId,
      'lastMessage': '',
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
      'participants': [studentId, teacherId],
    });
  }
}


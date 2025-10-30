import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id; // optional doc id
  final String text;
  final String senderId;
  final Timestamp timestamp;

  MessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.timestamp,
  });

  /// Create from a Firestore document snapshot
  factory MessageModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? <String, dynamic>{};
    return MessageModel(
      id: doc.id,
      text: data['text']?.toString() ?? '',
      senderId: data['senderId']?.toString() ?? '',
      // if timestamp missing or null, fallback to now (prevents the null cast crash)
      timestamp: (data['timestamp'] is Timestamp)
          ? data['timestamp'] as Timestamp
          : Timestamp.now(),
    );
  }

  /// Alternate constructor that accepts a raw map
  factory MessageModel.fromMap(Map<String, dynamic> data, {String id = ''}) {
    return MessageModel(
      id: id,
      text: data['text']?.toString() ?? '',
      senderId: data['senderId']?.toString() ?? '',
      timestamp: (data['timestamp'] is Timestamp)
          ? data['timestamp'] as Timestamp
          : Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'timestamp': timestamp,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String message;
  final int timestamp;
  final String type;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.message,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
      'type': type,
    };
  }

  factory MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return MessageModel(
      id: snapshot.id,
      senderId: data['senderId'],
      message: data['message'],
      timestamp: data['timestamp'],
      type: data['type'],
    );
  }
}

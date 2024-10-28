import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final String type;
  final List<String> participants;
  final String? groupName; 
  final int createdAt;
  final String lastMessage;
  final int lastMessageTimestamp;

  ChatRoomModel({
    required this.id,
    required this.type,
    required this.participants,
    this.groupName,
    required this.createdAt,
    required this.lastMessage,
    required this.lastMessageTimestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'participants': participants,
      'groupName': groupName,
      'createdAt': createdAt,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp,
    };
  }

  factory ChatRoomModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ChatRoomModel(
      id: snapshot.id,
      type: data['type'],
      participants: List<String>.from(data['participants']),
      groupName: data['groupName'],
      createdAt: data['createdAt'],
      lastMessage: data['lastMessage'],
      lastMessageTimestamp: data['lastMessageTimestamp'],
    );
  }
}

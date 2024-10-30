import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final String type;
  final List<String> participants;
  final String? groupName;
  final DateTime createdAt;
  final String lastMessage;
  final DateTime lastMessageTimestamp;

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
      'id': id,
      'type': type,
      'participants': participants,
      'groupName': groupName,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessage': lastMessage,
      'lastMessageTimestamp': Timestamp.fromDate(lastMessageTimestamp),
    };
  }

  factory ChatRoomModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ChatRoomModel(
      id: snapshot.id,
      type: data['type'],
      participants: List<String>.from(data['participants']),
      groupName: data['groupName'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'],
      lastMessageTimestamp:
          (data['lastMessageTimestamp'] as Timestamp).toDate(),
    );
  }
}

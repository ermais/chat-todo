import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String profilePictureUrl;
  final bool onlineStatus;
  final int lastSeen;
  final List<String> chats;

  UserModel({
    required this.id,
    required this.username,
    required this.profilePictureUrl,
    required this.onlineStatus,
    required this.lastSeen,
    required this.chats,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'profilePictureUrl': profilePictureUrl,
      'onlineStatus': onlineStatus,
      'lastSeen': lastSeen,
      'chats': chats,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      id: snapshot.id,
      username: data['username'],
      profilePictureUrl: data['profilePictureUrl'],
      onlineStatus: data['onlineStatus'],
      lastSeen: data['lastSeen'],
      chats: List<String>.from(data['chats']),
    );
  }
}

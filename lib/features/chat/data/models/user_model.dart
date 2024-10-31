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

  factory UserModel.fromMap(Map<String, dynamic> data, String userId) {
    return UserModel(
      id: userId,
      username: data['username'] as String,
      profilePictureUrl: data['profilePictureUrl'] as String,
      onlineStatus: data['onlineStatus'] as bool,
      lastSeen: data['lastSeen'] as int,
      chats: List.from(data['chats'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toMap(String userId) {
    return {
      'id': userId,
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

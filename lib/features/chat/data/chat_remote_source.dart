import 'dart:io';

import 'package:chat_todo/core/providers/firebase_providers.dart';
import 'package:chat_todo/core/providers/go_router_provider.dart';
import 'package:chat_todo/features/chat/data/models/chat_room_model.dart';
import 'package:chat_todo/features/chat/data/models/message_model.dart';
import 'package:chat_todo/features/chat/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRemoteSource {
  FirebaseFirestore _firebaseFirestore;
  Ref _ref;

  ChatRemoteSource(this._firebaseFirestore, this._ref);

  Future<Either<String, DocumentReference>> sendMessage(
      {required MessageModel messageModel, required String roomId}) async {
    try {
      final docRef = _firebaseFirestore
          .collection("messages")
          .doc(roomId)
          .collection("messages");
      await updateChatRoom(data: {
        'lastMessage': messageModel.type == 'text'
            ? messageModel.message
            : 'image attached!'
      }, roomId: roomId);
      final response = await docRef.add(messageModel.toMap());
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'sending message failed');
    }
  }

  Future<Either<String, DocumentReference>> sendMedia({
    required File file,
    required String type,
    required String roomId,
  }) async {
    final res = await uploadChatMedia(file, type);
    return await res.fold(
      (error) => Left(error),
      (downloadUrl) async {
        final message = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: _ref.read(firebaseAuthProvider).currentUser!.uid,
          message: downloadUrl!,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          type: type,
        );

        final messageRes =
            await sendMessage(messageModel: message, roomId: roomId);
        return messageRes.fold(
          (error) => Left(error),
          (docRef) => Right(docRef),
        );
      },
    );
  }

  Future<Either<String, String?>> uploadChatMedia(
      File file, String type) async {
    try {
      final storageRef = _ref.read(firebaseStorageProvider).ref();
      final fileRef = storageRef.child(
          'chats/${(type == 'audios') ? 'audio' : type == 'image' ? 'images' : 'videos'}/${_ref.read(firebaseAuthProvider).currentUser!.uid}/${file.path.split('/').last}');
      await fileRef.putFile(file);
      String? downloadUrl = await fileRef.getDownloadURL();
      return Right(downloadUrl);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'failed to upload');
    }
  }

  Future<Either<String, void>> updateChatRoom(
      {required Map<String, dynamic> data, required String roomId}) async {
    try {
      final docRef = _firebaseFirestore.collection("chat-rooms");
      final response = await docRef.doc(roomId).update(data);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(e.message ?? "failed to update");
    }
  }

  Future<Either<String, Stream<QuerySnapshot>>> getRoomMessages(
      {required String roomId}) async {
    try {
      final docRef = _firebaseFirestore
          .collection("messages")
          .doc(roomId)
          .collection("messages")
          .orderBy('timestamp', descending: false);
      final Stream<QuerySnapshot> response = docRef.snapshots();
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(e.message ?? "fetching room message failed");
    }
  }

  Future<Either<String, void>> registerUser(
      {required String userId, required UserModel user}) async {
    try {
      final docRef = _firebaseFirestore.collection("users").doc(userId);
      final response = await docRef
          .set(user.toMap(_ref.read(firebaseAuthProvider).currentUser!.uid));
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(e.message ?? "failed to create user");
    }
  }

  Future<Either<String, Stream<QuerySnapshot>>> getUsers() async {
    try {
      final docRef = _firebaseFirestore.collection("users").where('id',
          isNotEqualTo: _ref.read(firebaseAuthProvider).currentUser!.uid);
      final Stream<QuerySnapshot> response = await docRef.snapshots();
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'failed to fech users');
    }
  }

  Future<Either<String, UserModel>> getPeerUser(
      {required String peerId}) async {
    try {
      final response =
          await _firebaseFirestore.collection('users').doc(peerId).get();
      final UserModel user =
          UserModel.fromMap(response.data() as Map<String, dynamic>, peerId);
      return Right(user);
    } on FirebaseException catch (e) {
      return Left(e.message ?? "failed to load user");
    }
  }

  Future<Either<String, DocumentReference?>> createChatRoom(
      {required ChatRoomModel chatRoomModel}) async {
    try {
      bool alreadyExist = false;

      final snapshot = await _firebaseFirestore
          .collection('chat-rooms')
          .where('participants', arrayContainsAny: chatRoomModel.participants)
          .get();
      alreadyExist = snapshot.docs.any((doc) {
        final roomParticipants = List<String>.from(doc['participants']);

        return roomParticipants.contains(chatRoomModel.participants[0]) &&
            roomParticipants.contains(chatRoomModel.participants[1]);
      });

      if (!alreadyExist) {
        final response = await _firebaseFirestore
            .collection("chat-rooms")
            .add(chatRoomModel.toMap());
        _ref.read(goRouterProvider).pop();
        return Right(response);
      }
      return Right(null);
    } on FirebaseException catch (e) {
      return Left(e.message ?? "failed to create chat room");
    }
  }

  Future<Either<String, Stream<QuerySnapshot>>> fetchUserChatRooms(
      {required String userId}) async {
    try {
      final docRef = _firebaseFirestore.collection('chat-rooms');
      final Stream<QuerySnapshot> response =
          await docRef.where('participants', arrayContains: userId).snapshots();
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(e.message ?? "failed to fecth user chat rooms");
    }
  }
}

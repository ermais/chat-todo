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
      await updateChatRoom(
          data: {'lastMessage': messageModel.message}, roomId: roomId);
      final response = await docRef.add(messageModel.toMap());
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'sending message failed');
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
          .collection("messages");
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
      final response = await docRef.set(user.toMap());
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(e.message ?? "failed to create user");
    }
  }

  Future<Either<String, Stream<QuerySnapshot>>> getUsers() async {
    try {
      final docRef = _firebaseFirestore.collection("users");
      final Stream<QuerySnapshot> response = docRef.snapshots();
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
      return Left(e?.message ?? "failed to load user");
    }
  }

  Future<Either<String, DocumentReference>> createChatRoom(
      {required ChatRoomModel chatRoomModel}) async {
    try {
      final response = await _firebaseFirestore
          .collection("chat-rooms")
          .add(chatRoomModel.toMap());
      return Right(response);
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

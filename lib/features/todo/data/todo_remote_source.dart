import 'dart:io';

import 'package:chat_todo/core/providers/firebase_providers.dart';
import 'package:chat_todo/features/todo/domain/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoRemoteSource {
  final FirebaseFirestore _firebase;
  final Ref _ref;
  TodoRemoteSource(this._firebase, this._ref);

  Future<Either<String, DocumentReference<Map<String, dynamic>>>> addTodo(
      {required TodoModel todoModel, required List<File> files}) async {
    try {
      List<String> images = [];
      for (final file in files) {
        final res = await uploadDoc(file);
        res.fold((error) {}, (downloadUrl) {
          if (downloadUrl != null) {
            images = [...images, downloadUrl];
          }
        });
      }
      final docRef = _firebase.collection("todos");
      final docId = docRef.doc().id;
      final response =
          await docRef.add(todoModel.toMapWithImages(images, docId));
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'failed to create todo');
    }
  }

  Future<Either<String, void>> updateTodo(
      {required String todoId, required Map<String, dynamic> data}) async {
    try {
      debugPrint("todo Id : ${todoId}   data : ${data}");
      final collection = _firebase.collection("todos");
      final response = await collection.where("id", isEqualTo: todoId).get();
      response.docs.first.reference.update(data);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'failed to update tood');
    }
  }

  Future<Either<String, Stream<QuerySnapshot>>> getTodos() async {
    try {
      final response = _firebase.collection("todos");
      final Stream<QuerySnapshot> _snapshots = response.snapshots();
      return Right(_snapshots);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'could not fetch todos');
    }
  }

  Future<Either<String, String?>> uploadDoc(File file) async {
    try {
      debugPrint("File path ${file.path}");
      final storageRef = _ref.read(firebaseStorageProvider).ref();
      final fileRef = storageRef.child(
          'todoImages/${_ref.read(firebaseAuthProvider).currentUser!.uid}/${file.path.split('/').last}');
      await fileRef.putFile(file);
      String? downloadUrl = await fileRef.getDownloadURL();
      debugPrint("downloadUrl ${downloadUrl}");
      return Right(downloadUrl);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'failed to upload');
    }
  }
}

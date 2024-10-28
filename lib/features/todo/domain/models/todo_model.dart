import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime dueDate;
  final List<String> noteItems;
  final List<String> noteImages;
  final Color color;
  final String userId;
  final List<String> collaborators;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.dueDate,
    required this.noteItems,
    required this.noteImages,
    required this.color,
    required this.userId,
    required this.collaborators,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': Timestamp.fromDate(dueDate),
      'noteItems': noteItems,
      'noteImages': noteImages,
      'color': color.value,
      'userId': userId,
      'collaborators': collaborators,
    };
  }

  Map<String, dynamic> toMapWithImages(List<String> images, String docId) {
    return {
      'id': docId,
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': Timestamp.fromDate(dueDate),
      'noteItems': noteItems,
      'noteImages': images,
      'color': color.value,
      'userId': userId,
      'collaborators': collaborators,
    };
  }

  factory TodoModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return TodoModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dueDate: (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      noteItems: List<String>.from(data['noteItems'] ?? []),
      noteImages: List<String>.from(data['noteImages'] ?? []),
      color: Color(data['color'] ?? 0xFFFFFFFF),
      userId: data['userId'] ?? '',
      collaborators: List<String>.from(data['collaborators'] ?? []),
    );
  }
}

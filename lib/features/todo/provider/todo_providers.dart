import 'package:chat_todo/core/providers/firebase_providers.dart';
import 'package:chat_todo/features/todo/data/todo_remote_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoRemoteSourceProvider = Provider<TodoRemoteSource>(
  (ref) => TodoRemoteSource(ref.read(firebaseFirestoreProvider), ref),
);

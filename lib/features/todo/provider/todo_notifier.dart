import 'dart:async';

import 'package:chat_todo/core/providers/firebase_providers.dart';
import 'package:chat_todo/features/todo/data/todo_remote_source.dart';
import 'package:chat_todo/features/todo/domain/models/todo_model.dart';
import 'package:chat_todo/features/todo/provider/state/todo_state.dart';
import 'package:chat_todo/features/todo/provider/todo_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoNotifier extends StateNotifier<TodoState> {
  final TodoRemoteSource _todoRemoteSource;

  final Ref _ref;
  Timer? _debounce;
  TodoNotifier(this._todoRemoteSource, this._ref)
      : super(TodoState(todos: [], prevTodos: [])) {
    getTodos();
  }

  Future<void> getTodos() async {
    state = TodoState(todos: [], prevTodos: [], loading: true);
    final response = await _todoRemoteSource.getTodos();
    final User? user = _ref.read(firebaseAuthProvider).currentUser;
    response.fold((error) {
      state = TodoState(todos: [], prevTodos: [], loading: false, error: error);
    }, (res) {
      if (user != null) {
        if (_ref.read(firebaseAuthProvider).currentUser != null) {
          res.listen((_todos) {
            List<TodoModel> todos = _todos.docs
                .map((todo) => TodoModel.fromSnapshot(todo))
                .toList();
            state = TodoState(todos: todos, prevTodos: todos, loading: false);
          });
        }
      }
    });
  }

  Future<void> searchBy(String query) async {
    final _query = query.toLowerCase();
    final filtered = state.prevTodos
        .where((todo) =>
            todo.title.toLowerCase().contains(_query) ||
            todo.description.toLowerCase().contains(_query) ||
            todo.noteItems.any((item) => item.toLowerCase().contains(_query)))
        .toList();
    state = TodoState(todos: filtered, prevTodos: [...state.prevTodos]);
  }
}

final todoNotifierProvider = StateNotifierProvider<TodoNotifier, TodoState>(
  (ref) => TodoNotifier(ref.read(todoRemoteSourceProvider), ref),
);

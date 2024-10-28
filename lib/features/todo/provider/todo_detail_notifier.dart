import 'dart:async';

import 'package:chat_todo/features/todo/data/todo_remote_source.dart';
import 'package:chat_todo/features/todo/provider/state/todo_detail_state.dart';
import 'package:chat_todo/features/todo/provider/todo_notifier.dart';
import 'package:chat_todo/features/todo/provider/todo_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoDetailNotifier extends StateNotifier<TodoDetailState> {
  TodoRemoteSource _todoRemoteSource;
  Ref _ref;
  Timer? _debounce;

  TodoDetailNotifier(
    this._todoRemoteSource,
    this._ref,
  ) : super(TodoDetailState.initial()) {}

  Future<void> update(Map<String, dynamic> data, String todoId) async {
    final res = await _todoRemoteSource.updateTodo(todoId: todoId, data: data);
  }

  Future<void> getTodoById(String todoId) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () async {
      state = TodoDetailState.loading();
      final todo = _ref
          .read(todoNotifierProvider)
          .todos
          .where((_todo) => _todo.id == todoId)
          .toList()[0];
      state = TodoDetailState.completed(todo: todo);
    });
  }

  Future<void> updateTodo(
      {required String todoId, required Map<String, dynamic> data}) async {
    debugPrint("todoId >>>>>>>>>> ${todoId} data>>>>>>>>>>>>> ${data}");
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () async {
      final res =
          await _todoRemoteSource.updateTodo(todoId: todoId, data: data);
      // final todo = _ref
      //     .read(todoNotifierProvider)
      //     .todos
      //     .where((_todo) => _todo.id == todoId)
      //     .toList()[0];
      // state = TodoDetailState.completed(todo: todo);
      debugPrint("data >>>>>>>>>..>>>>>>>>>>>>>>> ${data}");
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final todoDetailNotifierProvider =
    StateNotifierProvider<TodoDetailNotifier, TodoDetailState>(
        (ref) => TodoDetailNotifier(ref.read(todoRemoteSourceProvider), ref));

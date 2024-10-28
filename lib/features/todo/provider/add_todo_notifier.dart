import 'dart:io';

import 'package:chat_todo/features/todo/data/todo_remote_source.dart';
import 'package:chat_todo/features/todo/domain/models/todo_model.dart';
import 'package:chat_todo/features/todo/provider/state/add_todo_state.dart';
import 'package:chat_todo/features/todo/provider/todo_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddTodoNotifier extends StateNotifier<AddTodoState> {
  final TodoRemoteSource _remoteSource;
  final Ref _ref;

  AddTodoNotifier(this._remoteSource, this._ref)
      : super(AddTodoState.initial());

  Future<void> addTodo(TodoModel todoModel, List<File> files) async {
    state = AddTodoState.uploading();
    final response =
        await _remoteSource.addTodo(todoModel: todoModel, files: files);
    state = response.fold((error) => AddTodoState.failure(message: error),
        (res) => AddTodoState.completed());
  }
}

final addTodoNotifierProvider =
    StateNotifierProvider<AddTodoNotifier, AddTodoState>(
        (ref) => AddTodoNotifier(ref.read(todoRemoteSourceProvider), ref));

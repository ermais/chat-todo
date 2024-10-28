import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_todo_state.freezed.dart';

@freezed
class AddTodoState with _$AddTodoState {
  const factory AddTodoState.initial() = _Initial;
  const factory AddTodoState.uploading() = _Uploading;
  const factory AddTodoState.completed() = _Completed;
  const factory AddTodoState.failure({String? message}) = _Failure;
}

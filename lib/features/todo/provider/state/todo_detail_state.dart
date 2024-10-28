import 'package:chat_todo/features/todo/domain/models/todo_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_detail_state.freezed.dart';

@freezed
class TodoDetailState with _$TodoDetailState {
  const factory TodoDetailState.initial() = _Initial;
  const factory TodoDetailState.loading() = _Loading;
  const factory TodoDetailState.completed({TodoModel? todo}) = _Completed;
  const factory TodoDetailState.failure({String? message}) = _Failure;
}

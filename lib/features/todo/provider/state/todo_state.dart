import 'package:chat_todo/features/todo/domain/models/todo_model.dart';

class TodoState {
  final List<TodoModel> todos;
  final List<TodoModel> prevTodos;
  final bool loading;
  final String? error;

  TodoState({
    required this.todos,
    required this.prevTodos,
    this.loading = false,
    this.error,
  });

  TodoState copyWith(
          {List<TodoModel>? todos,
          List<TodoModel>? prevTodos,
          bool? loading,
          String? error}) =>
      TodoState(
          todos: todos ?? this.todos,
          prevTodos: prevTodos ?? this.prevTodos,
          loading: loading ?? this.loading,
          error: error ?? this.error);
}

import 'package:chat_todo/core/utils/cal_grid_count.dart';
import 'package:chat_todo/features/todo/presentation/widgets/todo_item_box.dart';
import 'package:chat_todo/features/todo/provider/state/todo_state.dart';
import 'package:chat_todo/features/todo/provider/todo_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

class TodoListView extends HookConsumerWidget {
  final TodoState todoState;
  const TodoListView({required this.todoState, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      children: List.generate(
          todoState.todos.length,
          (index) => GestureDetector(
                onTap: () {
                  ref
                      .read(todoDetailNotifierProvider.notifier)
                      .getTodoById(todoState.todos[index].id);
                  context.go("/todo_detail");
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: todoState.todos[index].color,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      (todoState.todos[index].noteImages != null &&
                              todoState.todos[index].noteImages.isNotEmpty)
                          ? StaggeredGrid.count(
                              axisDirection: AxisDirection.down,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              crossAxisCount: calCrossAxisCount(
                                  todoState.todos[index].noteImages.length),
                              children: List.generate(
                                  todoState.todos[index].noteImages.length,
                                  (_index) => ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Image.network(
                                            todoState.todos[index]
                                                .noteImages[_index],
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      )),
                            )
                          : SizedBox.shrink(),
                      IntrinsicHeight(
                        child: Text(
                          todoState.todos[index].title,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Text(
                        todoState.todos[index].description,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        maxLines: 4,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                      ...List.generate(
                          todoState.todos[index].noteItems.length,
                          (_index) => TodoItemBox(
                                item: todoState.todos[index].noteItems[_index],
                                color: todoState.todos[index].color,
                              ))
                    ],
                  ),
                ),
              )),
    );
  }
}

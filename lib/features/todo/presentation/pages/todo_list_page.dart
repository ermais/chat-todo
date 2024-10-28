import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_todo/core/providers/firebase_providers.dart';
import 'package:chat_todo/features/todo/presentation/widgets/todo_list_view.dart';
import 'package:chat_todo/features/todo/provider/todo_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

class TodoListPage extends StatefulHookConsumerWidget {
  const TodoListPage({super.key});

  @override
  ConsumerState<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final todoState = ref.watch(todoNotifierProvider);
    final todoNotifier = ref.watch(todoNotifierProvider.notifier);

    if (todoState.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 56,
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        // BoxShadow(
                        //     color: Colors.black.withOpacity(0.2),
                        //     blurStyle: BlurStyle.outer,
                        //     blurRadius: 5,
                        //     offset: Offset(0, 8),
                        //     spreadRadius: 5)
                      ]),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.menu,
                          size: 24,
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Search Notes",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none),
                          onChanged: (String value) {
                            todoNotifier.searchBy(value);
                          },
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: SizedBox(
                          height: 48,
                          width: 48,
                          child: CachedNetworkImage(
                              imageUrl: ref
                                      .read(firebaseAuthProvider)
                                      .currentUser
                                      ?.photoURL ??
                                  ""),
                        ),
                      )
                    ],
                  ),
                ),
                //pinned
                SizedBox(
                  height: 24,
                ),
                TodoListView(todoState: todoState)
              ],
            ),
          ),
          Positioned(
              right: 16,
              bottom: 16,
              child: GestureDetector(
                onTap: () {
                  context.go('/add_todo');
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Icon(
                    CupertinoIcons.add,
                    size: 24,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ))
        ],
      ),
    ));
  }
}

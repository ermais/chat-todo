import 'package:chat_todo/features/auth/domain/state/auth_state.dart';
import 'package:chat_todo/features/auth/provider/auth_notifier.dart';
import 'package:chat_todo/features/chat/presentation/pages/chat_list_page.dart';
import 'package:chat_todo/features/todo/presentation/pages/todo_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.watch(authNotifierProvider.notifier);

    if (authState.runtimeType == AuthState.unauthenticated) {
      context.go('/login');
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              authNotifier.signOut();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.logout,
                size: 24,
              ),
            ),
          )
        ],
      ),
      body: Builder(builder: (context) {
        switch (_currentIndex) {
          case 0:
            return TodoListPage();
          case 1:
            return ChatListPage();
          default:
            return TodoListPage();
        }
        ;
      }),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.assignment,
                  size: 24,
                ),
                label: 'Todo'),
            BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.chat_bubble_2,
                  size: 24,
                ),
                label: 'Chat')
          ]),
    );
  }
}

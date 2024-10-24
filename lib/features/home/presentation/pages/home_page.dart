import 'package:chat_todo/features/chat/presentation/pages/chat_list_page.dart';
import 'package:chat_todo/features/todo/presentation/pages/todo_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: (){
              context.go("/login");
            },
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.logout),
              ),
          )
        ],
      ),
      body: Builder(builder: (context){
         switch(_currentIndex){
          case 0:
            return TodoListPage();
           case 1:
             return ChatListPage();
           default:
             return TodoListPage();
        };
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
          onTap: (int index){
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
        BottomNavigationBarItem(icon: Icon(Icons.assignment,size: 24,),label: 'Todo'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble_2,size: 24,),label: 'Chat')
      ]),
    );
  }
}

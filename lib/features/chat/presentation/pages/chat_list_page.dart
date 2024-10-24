import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Add friends to chat"),
      ),
    );
  }
}

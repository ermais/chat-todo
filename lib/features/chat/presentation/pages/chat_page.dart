import 'package:chat_todo/core/providers/firebase_providers.dart';
import 'package:chat_todo/features/chat/data/models/message_model.dart';
import 'package:chat_todo/features/chat/provider/chat_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatPage extends StatefulHookConsumerWidget {
  const ChatPage({required this.roomId, super.key});
  final String roomId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final roomMessages = ref.watch(chatNotifierProvider(widget.roomId));
    final roomMessageNotifier =
        ref.watch(chatNotifierProvider(widget.roomId).notifier);
    final userId = ref.read(firebaseAuthProvider).currentUser!.uid;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            roomMessages.when(
              completed: (messages) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(
                          messages?.length ?? 0,
                          (index) => Align(
                                alignment: (messages![index].senderId != userId)
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainer,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(24),
                                            topRight: Radius.circular(24),
                                            bottomRight: Radius.circular(
                                                (messages![index].senderId !=
                                                        userId)
                                                    ? 24
                                                    : 0),
                                            bottomLeft: Radius.circular(
                                                (messages![index].senderId !=
                                                        userId)
                                                    ? 0
                                                    : 24))),
                                    child: Text(messages![index].message)),
                              ))
                    ],
                  ),
                ),
              ),
              initial: () => Center(
                child: Text("Say hi"),
              ),
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
              failure: (String? error) => Center(
                child: Text(error ?? "Something wrong, please try later"),
              ),
            ),
            Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  height: 64,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(Icons.add),
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceBright,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: TextField(
                                  controller: _textEditingController,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      // filled: true,
                                      // fillColor: Theme.of(context)
                                      //     .colorScheme
                                      //     .primaryContainer,
                                      hintText: 'Type here',
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 48,
                          width: 48,
                          child: GestureDetector(
                            onTap: () {
                              final userId = ref
                                  .read(firebaseAuthProvider)
                                  .currentUser!
                                  .uid;
                              final message = MessageModel(
                                  id:
                                      '${userId}-${DateTime.now().millisecondsSinceEpoch}',
                                  senderId: userId,
                                  message: _textEditingController.text,
                                  timestamp:
                                      DateTime.now().millisecondsSinceEpoch,
                                  type: 'text');

                              roomMessageNotifier.sendMessage(
                                  message: message, roomId: widget.roomId);
                              _textEditingController.clear();
                            },
                            child: Icon(Icons.send,
                                size: 24,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}

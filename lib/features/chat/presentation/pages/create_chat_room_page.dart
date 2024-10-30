import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_todo/core/providers/firebase_providers.dart';
import 'package:chat_todo/features/chat/data/models/chat_room_model.dart';
import 'package:chat_todo/features/chat/provider/create_chat_room_notifier.dart';
import 'package:chat_todo/features/chat/provider/state/create_chat_room_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateChatRoomPage extends StatefulHookConsumerWidget {
  const CreateChatRoomPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateChatRoomPageState();
}

class _CreateChatRoomPageState extends ConsumerState<CreateChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(createChatRoomNotifierProvider);
    final createChatRoomNotifier =
        ref.watch(createChatRoomNotifierProvider.notifier);
    if (userState.runtimeType == CreateChatRoomState.created) {
      context.go('/');
    }
    return Scaffold(
        appBar: AppBar(),
        body: userState.when(
            initial: () => Center(
                  child: Text("Empty user found"),
                ),
            loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
            completed: (users) => Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "New Group",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          ...List.generate(
                              users?.length ?? 0,
                              (index) => GestureDetector(
                                    onTap: () {
                                      final chatRoom = ChatRoomModel(
                                          id:
                                              '${users[index].id}-${ref.read(firebaseAuthProvider).currentUser!.uid}',
                                          type: 'private',
                                          participants: [
                                            users[index].id,
                                            ref
                                                .read(firebaseAuthProvider)
                                                .currentUser!
                                                .uid
                                          ],
                                          createdAt: DateTime.now(),
                                          lastMessage: 'you',
                                          lastMessageTimestamp: DateTime.now());
                                      createChatRoomNotifier.createChatRoom(
                                          chatRoom: chatRoom);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerLow,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainerLowest))),
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          child: SizedBox(
                                            height: 48,
                                            width: 48,
                                            child: CachedNetworkImage(
                                                imageUrl: users![index]
                                                    .profilePictureUrl),
                                          ),
                                        ),
                                        title: Text(
                                          users![index].username ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                    ),
                                  ))
                        ],
                      ),
                    )
                  ],
                ),
            failure: (message) => Center(
                  child: Text(message ?? ""),
                ),
            created: (ChatRoomModel? chatRoom) => Center(
                  child: Text("successfully creted"),
                )));
  }
}

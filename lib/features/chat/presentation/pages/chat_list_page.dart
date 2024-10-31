import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_todo/core/utils/format_date.dart';
import 'package:chat_todo/features/chat/provider/chat_room_list_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    final chatListState = ref.watch(chatRoomListNotifierProvider);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            chatListState.when(
                initial: () => Center(
                      child: CircularProgressIndicator(),
                    ),
                loading: () => Center(
                      child: CircularProgressIndicator(),
                    ),
                completed: (chatRooms) => chatRooms != null &&
                        chatRooms.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            ...List.generate(
                                chatRooms?.length ?? 0,
                                (index) => GestureDetector(
                                      onTap: () {
                                        context.go('/chat',
                                            extra:
                                                chatRooms[index].chatRoom.id);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainer,
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceContainerHighest,
                                                    width: 1))),
                                        child: ListTile(
                                          leading: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            child: Container(
                                              height: 48,
                                              width: 48,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)),
                                              ),
                                              child: CachedNetworkImage(
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(
                                                            Icons.error,
                                                          ),
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  imageUrl: chatRooms![index]
                                                      .peerUser
                                                      .profilePictureUrl),
                                            ),
                                          ),
                                          title: Text(chatRooms[index]
                                              .peerUser
                                              .username),
                                          subtitle: Text(chatRooms[index]
                                              .chatRoom
                                              .lastMessage),
                                          trailing: Column(
                                            children: [
                                              Text(formatDate(chatRooms[index]
                                                  .chatRoom
                                                  .lastMessageTimestamp)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          'Empty chat room',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.w300,
                              ),
                        ),
                      ),
                failure: (error) => Center(
                      child: Text(
                        error ?? "Empt chat room",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )),
            Positioned(
                right: 16,
                bottom: 16,
                child: GestureDetector(
                  onTap: () {
                    context.go('/user_list');
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.chat_bubble,
                        size: 24,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

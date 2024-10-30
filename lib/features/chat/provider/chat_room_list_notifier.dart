import 'package:chat_todo/core/providers/firebase_providers.dart';
import 'package:chat_todo/features/chat/data/chat_remote_source.dart';
import 'package:chat_todo/features/chat/data/models/chat_room_model.dart';
import 'package:chat_todo/features/chat/data/models/chat_room_with_peer.dart';
import 'package:chat_todo/features/chat/provider/chat_remote_source_provider.dart';
import 'package:chat_todo/features/chat/provider/state/chat_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomListNotifier extends StateNotifier<ChatListState> {
  ChatRoomListNotifier(this._chatRemoteSource, this._ref)
      : super(ChatListState.initial()) {
    getUserRooms();
  }
  ChatRemoteSource _chatRemoteSource;
  Ref _ref;

  Future<void> getUserRooms() async {
    final userId = _ref.read(firebaseAuthProvider).currentUser!.uid;
    final res = await _chatRemoteSource.fetchUserChatRooms(userId: userId);
    res.fold((error) {
      state = ChatListState.failure(message: error);
    }, (res) {
      res.listen((snapshot) async {
        List<ChatRoomModel> chatRooms = snapshot.docs
            .map((doc) => ChatRoomModel.fromSnapshot(doc))
            .toList();
        List<ChatRoomWithPeer> chatRoomswithPeer = [];
        for (final room in chatRooms) {
          final res = await _chatRemoteSource.getPeerUser(
              peerId: room.participants.firstWhere((id) => id != userId));
          res.fold((error) => null, (peer) {
            chatRoomswithPeer = [
              ...chatRoomswithPeer,
              ChatRoomWithPeer(chatRoom: room, peerUser: peer)
            ];
          });
        }
        state = ChatListState.completed(chatRooms: chatRoomswithPeer);
      });
    });
  }
}

final chatRoomListNotifierProvider =
    StateNotifierProvider<ChatRoomListNotifier, ChatListState>(
  (ref) => ChatRoomListNotifier(ref.read(chatRemoteSourceProvider), ref),
);

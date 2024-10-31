import 'dart:io';

import 'package:chat_todo/features/chat/data/chat_remote_source.dart';
import 'package:chat_todo/features/chat/data/models/message_model.dart';
import 'package:chat_todo/features/chat/provider/chat_remote_source_provider.dart';
import 'package:chat_todo/features/chat/provider/state/room_message_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatNotifier extends StateNotifier<RoomMessageState> {
  ChatNotifier(this._chatRemoteSource, this._ref, this._roomId)
      : super(RoomMessageState.initial()) {
    getRoomMessage(roomId: _roomId);
  }
  ChatRemoteSource _chatRemoteSource;
  Ref _ref;
  String _roomId;
  Future<void> getRoomMessage({required String roomId}) async {
    final res = await _chatRemoteSource.getRoomMessages(roomId: roomId);
    res.fold((error) {
      state = RoomMessageState.failure(error: error);
    }, (res) {
      res.listen((snapshot) {
        List<MessageModel> messages =
            snapshot.docs.map((doc) => MessageModel.fromSnapshot(doc)).toList();
        state = RoomMessageState.completed(messages: messages);
      });
    });
  }

  Future<void> sendMessage(
      {required MessageModel message, required String roomId}) async {
    final res = await _chatRemoteSource.sendMessage(
        messageModel: message, roomId: roomId);
    res.fold((error) {}, (res) {});
  }

  Future<void> sendMedia(
      {required File file,
      required String type,
      required String roomId}) async {
    final res = await _chatRemoteSource.sendMedia(
        file: file, type: type, roomId: roomId);
    res.fold((error) {}, (message) {});
  }
}

final chatNotifierProvider =
    StateNotifierProvider.family<ChatNotifier, RoomMessageState, String>(
  (ref, roomId) =>
      ChatNotifier(ref.read(chatRemoteSourceProvider), ref, roomId),
);

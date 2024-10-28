import 'package:chat_todo/features/chat/data/models/chat_room_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_list_state.freezed.dart';

@freezed
class ChatListState with _$ChatListState {
  const factory ChatListState.initial() = _Initial;
  const factory ChatListState.loading() = _Loading;
  const factory ChatListState.completed({List<ChatRoomModel>? chatRooms}) =
      _Completed;
  const factory ChatListState.failure({String? message}) = _Failure;
}

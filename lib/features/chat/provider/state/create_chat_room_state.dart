import 'package:chat_todo/features/chat/data/models/chat_room_model.dart';
import 'package:chat_todo/features/chat/data/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat_room_state.freezed.dart';

@freezed
class CreateChatRoomState with _$CreateChatRoomState {
  const factory CreateChatRoomState.initial() = _Initial;
  const factory CreateChatRoomState.loading() = _Loading;
  const factory CreateChatRoomState.completed({List<UserModel>? users}) =
      _Completed;
  const factory CreateChatRoomState.failure({String? message}) = _Failure;
  const factory CreateChatRoomState.created({ChatRoomModel? chatRoom}) =
      _Created;
}

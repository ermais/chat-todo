import 'package:chat_todo/features/chat/data/models/message_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_message_state.freezed.dart';

@freezed
class RoomMessageState with _$RoomMessageState {
  const factory RoomMessageState.initial() = _Initial;
  const factory RoomMessageState.loading() = _Loading;
  const factory RoomMessageState.completed({List<MessageModel>? messages}) =
      _Completed;
  const factory RoomMessageState.failure({String? error}) = _Failure;
}

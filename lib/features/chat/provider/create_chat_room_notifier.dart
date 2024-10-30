import 'package:chat_todo/features/chat/data/chat_remote_source.dart';
import 'package:chat_todo/features/chat/data/models/chat_room_model.dart';
import 'package:chat_todo/features/chat/data/models/user_model.dart';
import 'package:chat_todo/features/chat/provider/chat_remote_source_provider.dart';
import 'package:chat_todo/features/chat/provider/state/create_chat_room_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateChatRoomNotifier extends StateNotifier<CreateChatRoomState> {
  ChatRemoteSource _chatRemoteSource;
  Ref _ref;
  CreateChatRoomNotifier(this._chatRemoteSource, this._ref)
      : super(CreateChatRoomState.initial()) {
    getusers();
  }

  Future<void> getusers() async {
    state = CreateChatRoomState.loading();
    final res = await _chatRemoteSource.getUsers();
    res.fold((error) {
      state = CreateChatRoomState.failure();
    }, (res) {
      res.listen((snapshot) {
        List<UserModel> users =
            snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
        state = CreateChatRoomState.completed(users: users);
      });
    });
  }

  Future<void> createChatRoom({required ChatRoomModel chatRoom}) async {
    final res = await _chatRemoteSource.createChatRoom(chatRoomModel: chatRoom);
    res.fold((error) {}, (res) {
      state = CreateChatRoomState.created();
    });
  }
}

final createChatRoomNotifierProvider =
    StateNotifierProvider<CreateChatRoomNotifier, CreateChatRoomState>(
  (ref) => CreateChatRoomNotifier(ref.read(chatRemoteSourceProvider), ref),
);

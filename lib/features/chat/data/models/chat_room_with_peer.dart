import 'package:chat_todo/features/chat/data/models/chat_room_model.dart';
import 'package:chat_todo/features/chat/data/models/user_model.dart';

class ChatRoomWithPeer {
  final ChatRoomModel chatRoom;
  final UserModel peerUser;

  ChatRoomWithPeer({
    required this.chatRoom,
    required this.peerUser,
  });
}

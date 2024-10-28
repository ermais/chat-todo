import 'package:chat_todo/core/providers/firebase_providers.dart';
import 'package:chat_todo/features/chat/data/chat_remote_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRemoteSourceProvider = Provider<ChatRemoteSource>(
    (ref) => ChatRemoteSource(ref.read(firebaseFirestoreProvider), ref));

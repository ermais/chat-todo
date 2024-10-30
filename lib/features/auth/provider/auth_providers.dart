import 'package:chat_todo/core/providers/firebase_providers.dart';
import 'package:chat_todo/features/auth/data/auth_remote_source.dart';
import 'package:chat_todo/features/chat/provider/chat_remote_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteSourceProvider = Provider<AuthRemoteSource>(
  (ref) => AuthRemoteSource(
      ref.read(firebaseAuthProvider), ref.read(chatRemoteSourceProvider), ref),
);

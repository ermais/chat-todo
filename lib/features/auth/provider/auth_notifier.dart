

import 'package:chat_todo/features/auth/data/auth_remote_source.dart';
import 'package:chat_todo/features/auth/domain/state/auth_state.dart';
import 'package:chat_todo/features/auth/provider/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier  extends StateNotifier<AuthState>{
    final AuthRemoteSource _authRemoteSource;
    AuthNotifier(this._authRemoteSource) : super(const AuthState.initial());

    Future<void> signIn({required String email,required String password}) async {
      state = AuthState.initial();
      final response = await _authRemoteSource.signIn(email: email, password: password);
      state = response.fold((error)=>AuthState.unauthenticated(message: error),
       (response)=>AuthState.authenticated(user: response));
    }

    Future<void> signUp({required String email, required String password}) async {
      state = AuthState.loadin();
      final response = await _authRemoteSource.signUp(email: email, password: password);
      state = response.fold((error)=>AuthState.unauthenticated(message: error), (res)=>AuthState.authenticated(user: res));
    }

    Future<void> continueWithGoogle() async {
      state = AuthState.loadin();
      final response = await _authRemoteSource.continueWithGoogle();
      state = response.fold((error)=>AuthState.unauthenticated(message: error), (res)=>AuthState.authenticated(user: res));
    }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier,AuthState>((ref) => AuthNotifier(ref.read(authRemoteSourceProvider)),);
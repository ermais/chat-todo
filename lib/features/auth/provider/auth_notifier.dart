import 'package:chat_todo/core/providers/firebase_providers.dart';
import 'package:chat_todo/features/auth/data/auth_remote_source.dart';
import 'package:chat_todo/features/auth/domain/state/auth_state.dart';
import 'package:chat_todo/features/auth/provider/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRemoteSource _authRemoteSource;
  final Ref _ref;
  AuthNotifier(this._authRemoteSource, this._ref)
      : super(const AuthState.initial()) {
    _ref.watch(firebaseAuthProvider).authStateChanges().listen((User? user) {
      if (user != null) {
        state = AuthState.authenticated(user: user);
      }
      if (user == null) {
        state = AuthState.unauthenticated();
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    state = AuthState.initial();
    final response =
        await _authRemoteSource.signIn(email: email, password: password);
    state = response.fold((error) => AuthState.unauthenticated(message: error),
        (response) => AuthState.authenticated(user: response));
  }

  Future<void> signUp({required String email, required String password}) async {
    state = AuthState.loadin();
    final response =
        await _authRemoteSource.signUp(email: email, password: password);
    state = response.fold((error) => AuthState.unauthenticated(message: error),
        (res) => AuthState.authenticated(user: res));
  }

  Future<void> continueWithGoogle() async {
    state = AuthState.loadin();
    final response = await _authRemoteSource.continueWithGoogle();
    state = response.fold((error) => AuthState.unauthenticated(message: error),
        (res) => AuthState.authenticated(user: res));
  }

  Future<void> signOut() async {
    final res = await _authRemoteSource.signOut();
    state = res.fold((error) => AuthState.unauthenticated(),
        (res) => AuthState.unauthenticated());
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRemoteSourceProvider), ref),
);

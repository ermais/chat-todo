import 'package:chat_todo/features/chat/data/chat_remote_source.dart';
import 'package:chat_todo/features/chat/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteSource {
  FirebaseAuth _firebaseAuth;
  Ref _ref;
  ChatRemoteSource _chatRemoteSource;

  AuthRemoteSource(this._firebaseAuth, this._chatRemoteSource, this._ref);
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Either<String, User>> signUp(
      {required String email, required String password}) async {
    try {
      final response = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return Right(response.user!);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "Failed to login");
    }
  }

  Future<Either<String, User>> signIn(
      {required String email, required String password}) async {
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return Right(response.user!);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "failed to login");
    }
  }

  Future<Either<String, User>> continueWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final response = await _firebaseAuth.signInWithCredential(credential);
        final User? currentUser = response.user;
        UserModel user = UserModel(
            id: currentUser!.uid,
            username: currentUser.displayName ?? "",
            profilePictureUrl: currentUser.photoURL ?? "",
            onlineStatus: false,
            lastSeen: DateTime.now().millisecondsSinceEpoch,
            chats: []);
        final res =
            await _chatRemoteSource.registerUser(user: user, userId: user.id);
        return Right(response.user!);
      } else {
        return Left('failed to login');
      }
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'failed to login');
    }
  }

  Future<Either<String, void>> signOut() async {
    try {
      final res = await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      return Right(res);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "failed to sign out");
    }
  }
}

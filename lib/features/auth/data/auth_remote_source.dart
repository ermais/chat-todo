

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteSource {
  FirebaseAuth _firebaseAuth;
  Ref _ref;

  AuthRemoteSource(this._firebaseAuth,this._ref);
  
  Future<Either<String,User>> signUp({required String email, required String password}) async {
    try {
      final response = await _firebaseAuth
      .createUserWithEmailAndPassword(email: email, password: password);
      return Right(response.user!);
    } on FirebaseAuthException  catch(e){
      return Left(e.message ?? "Failed to login");
    }
  }

  Future<Either<String, User>> signIn({required String email, required String password}) async {

    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return Right(response.user!);
    } on FirebaseAuthException catch (e) {
     return Left(e.message ?? "failed to login"); 
    }
  }

  Future<Either<String, User>> continueWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if(googleUser != null){
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential  credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final response = await _firebaseAuth.signInWithCredential(credential);
        
        return Right(response.user!);
      }else{
        return Left('failed to login');
      }
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'failed to login');
    }
  }
}
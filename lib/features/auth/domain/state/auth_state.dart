import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "auth_state.freezed.dart";

@freezed
class AuthState  with _$AuthState { 
  const factory AuthState.initial()= _Initial;
  const factory AuthState.loadin()= _Loading;
  const factory AuthState.unauthenticated({String? message})= _UnAuthenticated;
  const factory AuthState.authenticated({required User user}) = _Authenticated;
}
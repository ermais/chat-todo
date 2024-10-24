// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5nifi8vBQbQmvUmQmhKpfUxjB3Vy_Fpg',
    appId: '1:919131850922:android:0d4b6548b1f73cc52028d3',
    messagingSenderId: '919131850922',
    projectId: 'chat-todo-cdbc6',
    storageBucket: 'chat-todo-cdbc6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBppIzvcIIJqS-_kvIj_LA134F3NkQASBs',
    appId: '1:919131850922:ios:620bfff1ec8ef3382028d3',
    messagingSenderId: '919131850922',
    projectId: 'chat-todo-cdbc6',
    storageBucket: 'chat-todo-cdbc6.appspot.com',
    androidClientId: '919131850922-i196frisgktt4u724u98rt23uqg2c9aa.apps.googleusercontent.com',
    iosClientId: '919131850922-67gbjf7m8nb8qqiivrv8hbal8iuedgl0.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatTodo',
  );
}

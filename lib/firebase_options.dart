// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB1QSj5EdfTCUS_t_ok4TzUIH3GfGzirK0',
    appId: '1:448559867707:web:c5aac6c64668de90f9b91e',
    messagingSenderId: '448559867707',
    projectId: 'todo-challenge-309f8',
    authDomain: 'todo-challenge-309f8.firebaseapp.com',
    storageBucket: 'todo-challenge-309f8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAEqOJ7OBJ8axQVfDXnXIuccEAPenCPpwA',
    appId: '1:448559867707:android:38070e02dc6a42f3f9b91e',
    messagingSenderId: '448559867707',
    projectId: 'todo-challenge-309f8',
    storageBucket: 'todo-challenge-309f8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCaUtFDEcwwyvEx7pffRQHfZl3ZL4rD_g4',
    appId: '1:448559867707:ios:478b508655d83495f9b91e',
    messagingSenderId: '448559867707',
    projectId: 'todo-challenge-309f8',
    storageBucket: 'todo-challenge-309f8.appspot.com',
    iosBundleId: 'com.example.todoAppChallenge',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCaUtFDEcwwyvEx7pffRQHfZl3ZL4rD_g4',
    appId: '1:448559867707:ios:478b508655d83495f9b91e',
    messagingSenderId: '448559867707',
    projectId: 'todo-challenge-309f8',
    storageBucket: 'todo-challenge-309f8.appspot.com',
    iosBundleId: 'com.example.todoAppChallenge',
  );
}

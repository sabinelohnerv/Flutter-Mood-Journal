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
    apiKey: 'AIzaSyC7hDuZQ89_pIeH39R2GGRI-njATEPzBVo',
    appId: '1:492406327720:web:7abcaae350e21e1493b59d',
    messagingSenderId: '492406327720',
    projectId: 'etherease',
    authDomain: 'etherease.firebaseapp.com',
    storageBucket: 'etherease.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwALKhR8xwc9qd7ImBRLvzrwciRWnEWug',
    appId: '1:492406327720:android:64f8668438def89193b59d',
    messagingSenderId: '492406327720',
    projectId: 'etherease',
    storageBucket: 'etherease.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkpMGk9mEr-NjTEbbkoC1dwn-HMtaOR_M',
    appId: '1:492406327720:ios:59a4dd7ba9d4b79093b59d',
    messagingSenderId: '492406327720',
    projectId: 'etherease',
    storageBucket: 'etherease.appspot.com',
    iosBundleId: 'com.example.etherEase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBkpMGk9mEr-NjTEbbkoC1dwn-HMtaOR_M',
    appId: '1:492406327720:ios:c7f9ee5a8b2a8c8e93b59d',
    messagingSenderId: '492406327720',
    projectId: 'etherease',
    storageBucket: 'etherease.appspot.com',
    iosBundleId: 'com.example.etherEase.RunnerTests',
  );
}

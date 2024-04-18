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
    apiKey: 'AIzaSyBULhSsnv_-XHBeRepmc7j4HrpanEZYsV0',
    appId: '1:15692535959:web:de0055696d0176455771d2',
    messagingSenderId: '15692535959',
    projectId: 'pfa-naji',
    authDomain: 'pfa-naji.firebaseapp.com',
    storageBucket: 'pfa-naji.appspot.com',
    measurementId: 'G-6DVKH583S3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaIqTAae1e-o9IrVazdDDYpN8lsTTSp0U',
    appId: '1:15692535959:android:f661b6872c3a3ce55771d2',
    messagingSenderId: '15692535959',
    projectId: 'pfa-naji',
    storageBucket: 'pfa-naji.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBsZe8dkZgjBO6Vr2-s6JwvtsZ8KmXq0gg',
    appId: '1:15692535959:ios:d20fb345a17845645771d2',
    messagingSenderId: '15692535959',
    projectId: 'pfa-naji',
    storageBucket: 'pfa-naji.appspot.com',
    iosBundleId: 'com.example.pfaParkinson',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBsZe8dkZgjBO6Vr2-s6JwvtsZ8KmXq0gg',
    appId: '1:15692535959:ios:84f0ab03ac9f44155771d2',
    messagingSenderId: '15692535959',
    projectId: 'pfa-naji',
    storageBucket: 'pfa-naji.appspot.com',
    iosBundleId: 'com.example.pfaParkinson.RunnerTests',
  );
}

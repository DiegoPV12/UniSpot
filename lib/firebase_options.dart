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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCQkl0Pb8NRkqK28p_ypP5gDJB3YhbZAgA',
    appId: '1:1045026580000:web:6e459b351a7722e4d63e45',
    messagingSenderId: '1045026580000',
    projectId: 'univalle-reservation',
    authDomain: 'univalle-reservation.firebaseapp.com',
    storageBucket: 'univalle-reservation.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCEjk7fkX36jG9v6Fl35VdM_5LqC8Y7JBs',
    appId: '1:1045026580000:android:4c03af154f6c8e06d63e45',
    messagingSenderId: '1045026580000',
    projectId: 'univalle-reservation',
    storageBucket: 'univalle-reservation.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyApF6roIu3fB6Yf7yF51Ibsot-icUUmz3M',
    appId: '1:1045026580000:ios:79da47c82f80a6e7d63e45',
    messagingSenderId: '1045026580000',
    projectId: 'univalle-reservation',
    storageBucket: 'univalle-reservation.appspot.com',
    iosBundleId: 'com.example.unispot',
  );
}

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
        return windows;
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
    apiKey: 'AIzaSyDVaDeprT0UeOMZLp-P2l1M-dIi07Ywg_4',
    appId: '1:239263037515:web:5430961be93eee216635ce',
    messagingSenderId: '239263037515',
    projectId: 'pets-friends-ffb15',
    authDomain: 'pets-friends-ffb15.firebaseapp.com',
    storageBucket: 'pets-friends-ffb15.appspot.com',
    measurementId: 'G-TTBF6JPC3R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCEjZXT4O05-7KWd20tCfPaSJVAAVD_QSo',
    appId: '1:239263037515:android:671b580d0c37a98e6635ce',
    messagingSenderId: '239263037515',
    projectId: 'pets-friends-ffb15',
    storageBucket: 'pets-friends-ffb15.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCLVHTrdRjK9o3DhS2GBW3xtk6wCkUK1NI',
    appId: '1:239263037515:ios:7f74680ab33b4d656635ce',
    messagingSenderId: '239263037515',
    projectId: 'pets-friends-ffb15',
    storageBucket: 'pets-friends-ffb15.appspot.com',
    iosBundleId: 'com.example.petFriend',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCLVHTrdRjK9o3DhS2GBW3xtk6wCkUK1NI',
    appId: '1:239263037515:ios:7f74680ab33b4d656635ce',
    messagingSenderId: '239263037515',
    projectId: 'pets-friends-ffb15',
    storageBucket: 'pets-friends-ffb15.appspot.com',
    iosBundleId: 'com.example.petFriend',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDVaDeprT0UeOMZLp-P2l1M-dIi07Ywg_4',
    appId: '1:239263037515:web:fd28f97b4d9d2f9b6635ce',
    messagingSenderId: '239263037515',
    projectId: 'pets-friends-ffb15',
    authDomain: 'pets-friends-ffb15.firebaseapp.com',
    storageBucket: 'pets-friends-ffb15.appspot.com',
    measurementId: 'G-WTRDQTC58R',
  );
}

// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      // ignore: no_default_cases
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAbncMkJUG9cvPaWBYybIbRUEyNsS_D26g',
    appId: '1:685420208078:web:e358b9ce5cd193e652d59f',
    messagingSenderId: '685420208078',
    projectId: 'push-notification-1027-197d5',
    authDomain: 'push-notification-1027-197d5.firebaseapp.com',
    storageBucket: 'push-notification-1027-197d5.appspot.com',
    measurementId: 'G-HN66Q51GYS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBstzdObNboSI3M6M7aPqRXkm_e4__J1k0',
    appId: '1:685420208078:android:72c798365cdfdea952d59f',
    messagingSenderId: '685420208078',
    projectId: 'push-notification-1027-197d5',
    storageBucket: 'push-notification-1027-197d5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMTARYaNIMr6TrMktw3yiFy895mmR7Olk',
    appId: '1:685420208078:ios:b8a9049374627aaf52d59f',
    messagingSenderId: '685420208078',
    projectId: 'push-notification-1027-197d5',
    storageBucket: 'push-notification-1027-197d5.appspot.com',
    iosBundleId: 'com.example.testUdemyAmazonClone2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMTARYaNIMr6TrMktw3yiFy895mmR7Olk',
    appId: '1:685420208078:ios:0feb71023d57658052d59f',
    messagingSenderId: '685420208078',
    projectId: 'push-notification-1027-197d5',
    storageBucket: 'push-notification-1027-197d5.appspot.com',
    iosBundleId: 'com.example.testUdemyAmazonClone2.RunnerTests',
  );
}

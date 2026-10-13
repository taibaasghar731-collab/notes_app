
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
    apiKey: 'AIzaSyAVB2PJlSMYQdG40RuwCTKVJbGilLh1aqY',
    appId: '1:16000608048:web:3450bc2568388e26630af5',
    messagingSenderId: '16000608048',
    projectId: 'notes-app-85fa1',
    authDomain: 'notes-app-85fa1.firebaseapp.com',
    storageBucket: 'notes-app-85fa1.firebasestorage.app',
    measurementId: 'G-LY5EN6MJEH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCET5sJejX0AHOQ_bOPNGiXXj1dhmQAnoM',
    appId: '1:16000608048:android:fa7e68acd72b1f8d630af5',
    messagingSenderId: '16000608048',
    projectId: 'notes-app-85fa1',
    storageBucket: 'notes-app-85fa1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA37FiTZbIjrY3I3NI49nmboRH6-KXGCc4',
    appId: '1:16000608048:ios:97c7915720b16bfb630af5',
    messagingSenderId: '16000608048',
    projectId: 'notes-app-85fa1',
    storageBucket: 'notes-app-85fa1.firebasestorage.app',
    iosBundleId: 'com.example.notesApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA37FiTZbIjrY3I3NI49nmboRH6-KXGCc4',
    appId: '1:16000608048:ios:97c7915720b16bfb630af5',
    messagingSenderId: '16000608048',
    projectId: 'notes-app-85fa1',
    storageBucket: 'notes-app-85fa1.firebasestorage.app',
    iosBundleId: 'com.example.notesApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAVB2PJlSMYQdG40RuwCTKVJbGilLh1aqY',
    appId: '1:16000608048:web:1d766f657f5c02cc630af5',
    messagingSenderId: '16000608048',
    projectId: 'notes-app-85fa1',
    authDomain: 'notes-app-85fa1.firebaseapp.com',
    storageBucket: 'notes-app-85fa1.firebasestorage.app',
    measurementId: 'G-C341841MJW',
  );
}

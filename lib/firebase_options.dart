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
    apiKey: 'AIzaSyCCkenLCX-mkL4Q_938ZHdZEqwU4N1igm0',
    appId: '1:629584258883:web:ad70017f762bb21305f1f6',
    messagingSenderId: '629584258883',
    projectId: 'perdidosya-58f0c',
    authDomain: 'perdidosya-58f0c.firebaseapp.com',
    storageBucket: 'perdidosya-58f0c.appspot.com',
    measurementId: 'G-C6693EVEN9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBkrbunmptcZha5CMEeJqx6_jJvBWcLq0',
    appId: '1:629584258883:android:f979e5cc92c23d3f05f1f6',
    messagingSenderId: '629584258883',
    projectId: 'perdidosya-58f0c',
    storageBucket: 'perdidosya-58f0c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPMhPqINM8k2FHCsBZIHzg9OTFCEPD6Nc',
    appId: '1:629584258883:ios:7cb72e521675aa6405f1f6',
    messagingSenderId: '629584258883',
    projectId: 'perdidosya-58f0c',
    storageBucket: 'perdidosya-58f0c.appspot.com',
    iosBundleId: 'com.example.perdidosYa',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDPMhPqINM8k2FHCsBZIHzg9OTFCEPD6Nc',
    appId: '1:629584258883:ios:7cb72e521675aa6405f1f6',
    messagingSenderId: '629584258883',
    projectId: 'perdidosya-58f0c',
    storageBucket: 'perdidosya-58f0c.appspot.com',
    iosBundleId: 'com.example.perdidosYa',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCCkenLCX-mkL4Q_938ZHdZEqwU4N1igm0',
    appId: '1:629584258883:web:1bbfa5fc040b892c05f1f6',
    messagingSenderId: '629584258883',
    projectId: 'perdidosya-58f0c',
    authDomain: 'perdidosya-58f0c.firebaseapp.com',
    storageBucket: 'perdidosya-58f0c.appspot.com',
    measurementId: 'G-VZXRT0BLFQ',
  );
}

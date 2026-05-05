import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {

  static FirebaseOptions get currentPlatform {

    return web;
  }

  static const FirebaseOptions web =
      FirebaseOptions(

    apiKey:
        'AIzaSyDQcvxM068X_tDg071-S2cfR2TwUi7GkBA',

    appId:
        '1:1049808356670:web:applemusiccrud',

    messagingSenderId:
        '1049808356670',

    projectId:
        'applemusiccrud',

    storageBucket:
        'applemusiccrud.firebasestorage.app',

    authDomain:
        'applemusiccrud.firebaseapp.com',
  );
}
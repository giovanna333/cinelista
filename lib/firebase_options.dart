import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError('Configurado apenas para web.');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA1WGjiZW44paZceNmdq2eT_WDY3CjkgWA',
    appId: '1:91714328614:web:40adf87078211deb3f2ee7',
    messagingSenderId: '91714328614',
    projectId: 'cinelista-27e7e',
    authDomain: 'cinelista-27e7e.firebaseapp.com',
    storageBucket: 'cinelista-27e7e.firebasestorage.app',
  );
}

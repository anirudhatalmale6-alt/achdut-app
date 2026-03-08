import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCh8tRlm7k8wSmDvo8B8eJ1xe9gbhWCb4w",
            authDomain: "achdut-uqtbsu.firebaseapp.com",
            projectId: "achdut-uqtbsu",
            storageBucket: "achdut-uqtbsu.firebasestorage.app",
            messagingSenderId: "290008916934",
            appId: "1:290008916934:web:dd3488ec90144e2e9988c7"));
  } else {
    await Firebase.initializeApp();
  }
}

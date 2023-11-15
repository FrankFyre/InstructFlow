// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instructflow/pages/home.dart';
import 'package:instructflow/loadingscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: 'AIzaSyBWtVp9BAZeHTgDvb81lOJqE3oFVVom7DM',
      appId: '1:428922308220:web:8c9036da81c359657febf9',
      messagingSenderId: '428922308220',
      projectId: 'instructflow',
      authDomain: 'instructflow.firebaseapp.com',
      databaseURL:
          'https://instructflow-default-rtdb.asia-southeast1.firebasedatabase.app',
      storageBucket: 'instructflow.appspot.com',
      measurementId: 'G-E5HVGS53WY',
    ));
  }

  await Firebase.initializeApp(
      name: "devproject", options: DefaultFirebaseOptions.currentPlatform);

  if (kIsWeb == false) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingScreen(),
        '/home': (context) => Home(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

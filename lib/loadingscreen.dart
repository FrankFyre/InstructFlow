// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instructflow/pages/home.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> loadAssets() async {
    if (kIsWeb) {
      // Navigate to the main page after loading
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                Home()), // Replace MyApp with your main page widget
      );
    }
    FirebaseStorage storage = FirebaseStorage.instance;

    List<String> storageLinks = [
      "/Checklist/photos",
      "/Employee",
      "/Recipes/Steps/images",
      "/Recipes/Thumbnails",
      "/Tasks/image",
    ];

    try {
      for (String link in storageLinks) {
        ListResult result = await storage.ref().child(link).listAll();

        // Precache images and store them in the cache
        await Future.forEach(result.items, (Reference reference) async {
          String downloadURL = await reference.getDownloadURL();
          await DefaultCacheManager().downloadFile(downloadURL);
        });
      }
    } catch (e) {
      print("Error listing files: $e");
    }

    // Navigate to the main page after loading
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) =>
              Home()), // Replace MyApp with your main page widget
    );
  }

  @override
  void initState() {
    super.initState();
    loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.dotsTriangle(
          color: Colors.amber,
          size: 200,
        ), // or any other loading indicator
      ),
    );
  }
}

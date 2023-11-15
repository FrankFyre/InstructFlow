import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:instructflow/classtypes/checklistclass.dart';
import 'package:instructflow/classtypes/checklistintructions.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class FirebaseUtils {
  static final storage = FirebaseStorage.instance;
  static final database = FirebaseDatabase.instance;

  static Future<void> saveCheckToFirebase(checklistclass check, nameController,
      keyid, List<checklistintruct> steps, context) async {
    final ref = database.ref().child('checklist');
    final recipeRef = ref.child(keyid);
    print(keyid);

    final checklist = {
      'name': nameController.text,
      'instruction': _formatSteps(steps),
    };

    await recipeRef.update(checklist);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checklist saved successfully!'),
      ),
    );
  }

  static Map<String, dynamic> _formatSteps(List<checklistintruct> steps) {
    final formattedSteps = <String, dynamic>{};
    for (int i = 0; i < steps.length; i++) {
      final step = steps[i];
      formattedSteps['check_item_${i + 1}'] = {
        'description': step.description,
        'image': step.media,
        'count': step.count,
        'videocheck': step.isvideo,
      };
    }
    return formattedSteps;
  }

  static Future<String> uploadImageToStorage(File imageFile, video) async {
    final storageRef = storage.ref();
    final imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final imageRef = storageRef.child(video
        ? 'Checklist/videos/$imageFileName'
        : 'Checklist/photos/$imageFileName');

    final uploadTask = imageRef.putFile(imageFile);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  static Future<void> saveNewCheckToFirebase(
    checklistclass recipe,
    nameController,
    List<checklistintruct> steps,
    context,
  ) async {
    final ref = database.ref().child('checklist');

    // Use the push method to generate a new unique key
    final recipeRef = ref.push();

    final recipeData = {
      'name': nameController.text,
      'instruction': _formatSteps(steps),
    };

    await recipeRef.set(recipeData); // Use set to save the data

    // Optionally, you can show a success message or navigate to a different screen after saving.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New checklist saved successfully!'),
      ),
    );
  }

  static Future<void> deleteChecklist(String keyid, steps, context) async {
    final ref = database.ref().child('checklist');
    final recipeRef = ref.child(keyid);
    print("enter delete");
    print(keyid);

    try {
      for (int index = 0; index < steps.length; index++) {
        await storage.refFromURL(steps[index].media).delete();
      }
      await recipeRef.remove();
    } catch (e) {
      print(e);
      // Handle any potential errors here, such as network issues or permissions.
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checklist deleted successfully!'),
      ),
    );
  }
}

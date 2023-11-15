import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:instructflow/classtypes/recipedata.dart';
import 'package:instructflow/classtypes/stepsrecipe.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class FirebaseUtils {
  static final storage = FirebaseStorage.instance;
  static final database = FirebaseDatabase.instance;

  static Future<void> saveRecipeToFirebase(Recipe recipe, nameController, keyid,
      menuid, List<StepsRecipe> steps, context) async {
    final ref = database.ref().child('recipes');
    final recipeRef = ref.child(keyid);

    final recipeData = {
      'name': nameController.text,
      'steps': _formatSteps(steps),
      'thumbnail': recipe.thumbnail,
      'uid': menuid,
    };

    await recipeRef.update(recipeData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recipe saved successfully!'),
      ),
    );
  }

  static Map<String, dynamic> _formatSteps(List<StepsRecipe> steps) {
    final formattedSteps = <String, dynamic>{};
    for (int i = 0; i < steps.length; i++) {
      final step = steps[i];
      formattedSteps['step_${i + 1}'] = {
        'description': step.description,
        'image_url': step.ImgUrl,
        'stepcount': step.stepcount,
        'video_url': step.isvid,
      };
    }

    return formattedSteps;
  }

  static Future<String> uploadImageToStorage(File imageFile, video) async {
    final storageRef = storage.ref();
    final imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final imageRef = storageRef.child(video
        ? 'Recipes/Steps/videos/$imageFileName'
        : 'Recipes/Steps/images/$imageFileName');

    final uploadTask = imageRef.putFile(imageFile);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  static Future<String> uploadthumbToStorage(
    File imageFile,
  ) async {
    final storageRef = storage.ref();
    final imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final imageRef = storageRef.child('Recipes/Thumnbnails/$imageFileName');

    final uploadTask = imageRef.putFile(imageFile);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  static Future<void> saveNewRecipeToFirebase(
    Recipe recipe,
    nameController,
    String menuid,
    List<StepsRecipe> steps,
    context,
  ) async {
    final ref = database.ref().child('recipes');

    // Use the push method to generate a new unique key
    final recipeRef = ref.push();

    final recipeData = {
      'name': nameController.text,
      'steps': _formatSteps(steps),
      'thumbnail': recipe.thumbnail,
      'uid': recipe.uniqid,
    };

    await recipeRef.set(recipeData); // Use set to save the data

    // Optionally, you can show a success message or navigate to a different screen after saving.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recipe saved successfully!'),
      ),
    );
  }

  static Future<void> deleteRecipe(
      String keyid, steps, thumbnail, context) async {
    final ref = database.ref().child('recipes');
    final recipeRef = ref.child(keyid);
    await recipeRef.remove();

    try {
      for (int index = 0; index < steps.length; index++) {
        await storage.refFromURL(steps[index].ImgUrl).delete();
      }
      await storage.refFromURL(thumbnail).delete();
    } catch (e) {
      // Handle any potential errors here, such as network issues or permissions.
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recipe saved successfully!'),
      ),
    );
  }
}

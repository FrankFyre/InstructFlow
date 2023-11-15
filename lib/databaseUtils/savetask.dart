import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:instructflow/classtypes/taskclass.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirebaseUtils {
  static final storage = FirebaseStorage.instance;
  static final database = FirebaseDatabase.instance;

  static Future<void> saveTaskToFirebase(
      TaskClass task, nameController, context) async {
    final ref = database.ref().child('tasks');
    final taskRef = ref.child(task.keyid);

    final employeeData = {
      'name': nameController,
      'mediaUrl': task.mediaUrl,
      'description': task.description,
      'videocheck': task.isvideo,
    };

    await taskRef.update(employeeData);

    // Optionally, you can show a success message or navigate to a different screen after saving.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task updated successfully!'),
      ),
    );
  }

  static Future<String> uploadImageToStorage(File imageFile, video) async {
    final storageRef = storage.ref();
    final imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final imageRef = storageRef.child(
        video ? 'Tasks/video/$imageFileName' : 'Tasks/image/$imageFileName');

    final uploadTask = imageRef.putFile(imageFile);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  static Future<void> deleteTask(String keyid, url, context) async {
    final ref = database.ref().child('tasks');
    final employeeRef = ref.child(keyid);
    await employeeRef.remove();

    try {
      await storage.refFromURL(url).delete();
    } catch (e) {
      // Handle any potential errors here, such as network issues or permissions.
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Employee deleted successfully!'),
      ),
    );
  }

  static Future<void> deleteOnGoingTask(String keyid, context) async {
    final ref = database.ref().child('ongoingTasks');
    final employeeRef = ref.child(keyid);

    try {
      await employeeRef.remove();
    } catch (e) {
      // Handle any potential errors here, such as network issues or permissions.
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Employee deleted successfully!'),
      ),
    );
  }

  static Future<void> saveNewtaskToFirebase(
    TaskClass task,
    nameController,
    context,
  ) async {
    final ref = database.ref().child('tasks');
    final employeeRef = ref.push();

    final employeeData = {
      'name': nameController,
      'mediaUrl': task.mediaUrl,
      'description': task.description,
      'videocheck': task.isvideo,
    };

    await employeeRef.update(employeeData);

    // Optionally, you can show a success message or navigate to a different screen after saving.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Employee saved successfully!'),
      ),
    );
  }

  static Future<void> addTaskToOngoingTasks(
      String assignedEmployee, TaskClass task, context) async {
    final ref = database.ref().child('ongoingTasks');

    try {
      // Push a new child node to generate a unique key
      final newTaskRef = ref.push();

      // Create a map with task data
      final taskData = {
        'assignedEmployee': assignedEmployee,
        'description': task.description,
        'mediaUrl': task.mediaUrl,
        'name': task.name,
        'videocheck': task.isvideo,
        'date': DateFormat(" dd,MMMM, yyyy").format(DateTime.now()),
        'time': DateFormat("HH:mm:ss").format(DateTime.now()),
      };

      // Set the data for the new task
      await newTaskRef.set(taskData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task assigned successfully!'),
        ),
      );
    } catch (e) {
      // Handle any potential errors here, such as network issues or permissions.
      print('Error adding task to ongoingTasks: $e');
    }
  }
}

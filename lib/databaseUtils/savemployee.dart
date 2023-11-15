import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:instructflow/classtypes/employeedata.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class FirebaseUtils {
  static final storage = FirebaseStorage.instance;
  static final database = FirebaseDatabase.instance;

  static Future<void> saveEmployeeToFirebase(
      Employee employee, nameController, context, keyid) async {
    final ref = database.ref().child('employees');
    final employeeRef = ref.child(employee.keyid);

    final employeeData = {
      'name': nameController,
      'thumbnail': employee.thumbnail,
      'uid': employee.uniqid,
    };

    await employeeRef.update(employeeData);

    // Optionally, you can show a success message or navigate to a different screen after saving.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Employee saved successfully!'),
      ),
    );
  }

  static Future<String> uploadImageToStorage(File imageFile) async {
    final storageRef = storage.ref();
    final imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final imageRef = storageRef.child('Employees/$imageFileName');

    final uploadTask = imageRef.putFile(imageFile);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  static Future<void> deleteEmployee(String keyid, url, context) async {
    final ref = database.ref().child('employees');
    final employeeRef = ref.child(keyid);

    try {
      await employeeRef.remove();
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

  static Future<void> saveNewEmployeeToFirebase(
    Employee employee,
    nameController,
    context,
  ) async {
    final ref = database.ref().child('employees');
    final employeeRef = ref.push();

    final employeeData = {
      'name': employee.name,
      'thumbnail': employee.thumbnail,
      'uid': employee.uniqid,
    };

    await employeeRef.update(employeeData);

    // Optionally, you can show a success message or navigate to a different screen after saving.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Employee saved successfully!'),
      ),
    );
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:instructflow/classtypes/taskclass.dart';

Future<List<List<TaskClass>>> getTaskdonelog() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('completedTasks').get();

  if (snapshot.exists) {
    var value = Map<String, dynamic>.from(snapshot.value as Map);
    List<TaskClass> export = [];

    value.forEach((key, value) {
      String name = value['name'];
      String keyer = key;
      String description = value['description'];
      String assigned = value['assignedEmployee'];
      String mediaUrl = value['mediaUrl'];
      String date = value['date'];
      String time = value['time'];
      bool isvideo = value['videocheck'];

      // Create a Recipe object
      TaskClass log = TaskClass(
          name: name,
          keyid: keyer,
          description: description,
          assigned: assigned,
          mediaUrl: mediaUrl,
          date: date,
          time: time,
          isvideo: isvideo);

      export.add(log);
    });
    export.sort((b, a) => a.date!.compareTo(b.date!));

    //print(export.toString());
    return [export];
  } else {
    // Handle the case where no data is available.
    // You can print a message or return an empty list as you did.
    // print('No data available.');
    return [];
  }
}

Future<List<List<TaskClass>>> getTaskongoinglog() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('ongoingTasks').get();

  if (snapshot.exists) {
    var value = Map<String, dynamic>.from(snapshot.value as Map);
    List<TaskClass> export = [];
    print('snap got');

    value.forEach((key, value) {
      String name = value['name'];
      String keyer = key;
      String description = value['description'];
      String assigned = value['assignedEmployee'];
      String mediaUrl = value['mediaUrl'];
      bool isvideo = value['videocheck'];

      // Create a Recipe object
      TaskClass log = TaskClass(
          name: name,
          keyid: keyer,
          description: description,
          assigned: assigned,
          mediaUrl: mediaUrl,
          isvideo: isvideo);

      export.add(log);
    });

    //print(export.toString());
    return [export];
  } else {
    // Handle the case where no data is available.
    // You can print a message or return an empty list as you did.
    // print('No data available.');
    return [];
  }
}

Future<List<TaskClass>> getTaskdonelog1() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('completedTasks').get();

  if (snapshot.exists) {
    var value = Map<String, dynamic>.from(snapshot.value as Map);
    List<TaskClass> export = [];

    value.forEach((key, value) {
      String name = value['name'];
      String keyer = key;
      String description = value['description'];
      String assigned = value['assignedEmployee'];
      String mediaUrl = value['mediaUrl'];
      String date = value['date'];
      String time = value['time'];
      bool isvideo = value['videocheck'];

      // Create a Recipe object
      TaskClass log = TaskClass(
          name: name,
          keyid: keyer,
          description: description,
          assigned: assigned,
          mediaUrl: mediaUrl,
          date: date,
          time: time,
          isvideo: isvideo);

      export.add(log);
    });
    export.sort((b, a) => a.date!.compareTo(b.date!));

    //print(export.toString());
    return export;
  } else {
    // Handle the case where no data is available.
    // You can print a message or return an empty list as you did.
    // print('No data available.');
    return [];
  }
}

Future<List<TaskClass>> getTaskongoinglog1() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('ongoingTasks').get();

  if (snapshot.exists) {
    var value = Map<String, dynamic>.from(snapshot.value as Map);
    List<TaskClass> export = [];
    print('snap got');

    value.forEach((key, value) {
      String name = value['name'];
      String keyer = key;
      String description = value['description'];
      String assigned = value['assignedEmployee'];
      String mediaUrl = value['mediaUrl'];
      String date = value['date'];
      String time = value['time'];
      bool isvideo = value['videocheck'];

      // Create a Recipe object
      TaskClass log = TaskClass(
          name: name,
          keyid: keyer,
          description: description,
          assigned: assigned,
          mediaUrl: mediaUrl,
          date: date,
          time: time,
          isvideo: isvideo);

      export.add(log);
    });

    //print(export.toString());
    return export;
  } else {
    // Handle the case where no data is available.
    // You can print a message or return an empty list as you did.
    // print('No data available.');
    return [];
  }
}

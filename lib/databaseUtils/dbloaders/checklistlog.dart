import 'package:firebase_database/firebase_database.dart';
import 'package:instructflow/classtypes/checklogs.dart';

Future<List<List<checklistlogs>>> getChecklistlog() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('checklogs').get();

  if (snapshot.exists) {
    var value = Map<String, dynamic>.from(snapshot.value as Map);
    List<checklistlogs> export = [];

    value.forEach((key, value) {
      String name = value['checklistName'];
      String employename = value['employeeName'];
      String date = value['date'];
      String time = value['time'];

      // Create a Recipe object
      checklistlogs log = checklistlogs(
        name: name,
        employename: employename,
        date: date,
        time: time,
      );

      export.add(log);
    });
    export.sort((b, a) => a.date.compareTo(b.date));

    //print(export.toString());
    return [export];
  } else {
    // Handle the case where no data is available.
    // You can print a message or return an empty list as you did.
    // print('No data available.');
    return [];
  }
}

Future<List<checklistlogs>> get2log() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('checklogs').get();

  if (snapshot.exists) {
    var value = Map<String, dynamic>.from(snapshot.value as Map);
    List<checklistlogs> export = [];

    value.forEach((key, value) {
      String name = value['checklistName'];
      String employename = value['employeeName'];
      String date = value['date'];
      String time = value['time'];

      // Create a Recipe object
      checklistlogs log = checklistlogs(
        name: name,
        employename: employename,
        date: date,
        time: time,
      );

      export.add(log);
    });
    export.sort((b, a) => a.date.compareTo(b.date));

    //print(export.toString());
    return export;
  } else {
    // Handle the case where no data is available.
    // You can print a message or return an empty list as you did.
    // print('No data available.');
    return [];
  }
}

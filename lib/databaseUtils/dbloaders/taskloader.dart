import 'package:firebase_database/firebase_database.dart';
import 'package:instructflow/classtypes/taskclass.dart';

Future<List<List<TaskClass>>> cehckemployeetaskdb(employeeName) async {
  final DatabaseReference _DB =
      FirebaseDatabase.instance.ref().child("ongoingTasks");

  final Event = await _DB.once();

  List<TaskClass> tasklist = [];

  if (Event.snapshot.exists) {
    var tasks = Map<String, dynamic>.from(Event.snapshot.value as Map);

    tasks.forEach((key, value) {
      String keyer = key;
      String namer = value['name'];
      String descrip = value['description'];
      String assign = value['assignedEmployee'];
      String url = value['mediaUrl'];
      bool isvideo = value['videocheck'];

      TaskClass task = TaskClass(
        keyid: keyer,
        name: namer,
        description: descrip,
        assigned: assign,
        mediaUrl: url,
        isvideo: isvideo,
      );
      tasklist.add(task);
    });

    return [tasklist];
  } else {
    print("no snapshiot");
    return [];
  }
}

Future<List<List<TaskClass>>> getTask() async {
  final DatabaseReference _DB = FirebaseDatabase.instance.ref();

  final snapshot = await _DB.child('tasks').get();

  List<TaskClass> tasklist = [];

  if (snapshot.exists) {
    var tasks = Map<String, dynamic>.from(snapshot.value as Map);

    tasks.forEach((key, value) {
      String keyer = key;
      String namer = value['name'];
      String descrip = value['description'];

      String assign = value['assignedEmployee'] ?? 'Default Value';
      String Url = value['mediaUrl'];
      bool isvideo = value['videocheck'];

      TaskClass task = TaskClass(
          keyid: keyer,
          name: namer,
          description: descrip,
          assigned: assign,
          mediaUrl: Url,
          isvideo: isvideo);
      tasklist.add(task);
    });
    return [tasklist];
  } else {
    return [];
  }
}

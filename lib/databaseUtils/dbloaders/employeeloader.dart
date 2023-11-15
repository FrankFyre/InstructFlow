import 'package:firebase_database/firebase_database.dart';
import 'package:instructflow/classtypes/employeedata.dart';

Future<List<List<Employee>>> getEmployeeDb() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('employees').get();

  if (snapshot.exists) {
    var value = Map<String, dynamic>.from(snapshot.value as Map);
    List<List<Employee>> export = [];

    value.forEach((key, value) {
      String keyer = key;
      String uid = value['uid'].toString();
      String name = value['name'];
      String profilePicture = value['thumbnail'];

      // Create an Employee object
      Employee employee = Employee(
          keyid: keyer, uniqid: uid, name: name, thumbnail: profilePicture);

      //print(employee.name);

      // Create a list containing the Employee object
      List<Employee> mylist = [employee];
      export.add(mylist);
    });
    //print(export.toString());
    export.sort((a, b) =>
        int.parse(a.first.uniqid).compareTo(int.parse(b.first.uniqid)));

    return export;
  } else {
    // Handle the case where no data is available.
    // You can print a message or return an empty list as you did.
    // print('No data available.');
    return [];
  }
}

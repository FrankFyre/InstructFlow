import 'package:firebase_database/firebase_database.dart';
import 'package:instructflow/classtypes/checklistclass.dart';
import 'package:instructflow/classtypes/checklistintructions.dart';

Future<List<List<checklistclass>>> getChecklistDb() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('checklist').get();
  bool checkvideo = false; //temp
  if (snapshot.exists) {
    var value = Map<String, dynamic>.from(snapshot.value as Map);
    List<checklistclass> export = [];

    value.forEach((key, value) {
      String keyid = key;
      String name = value['name'];
      Object instruction = value['instruction'];

      var stepvalues = Map<String, dynamic>.from(instruction as Map);

      // Convert stepsData into a list of StepsRecipe objects
      List<checklistintruct> steps = [];

      stepvalues.forEach((stepKey, stepValue) {
        String description = stepValue['description'];
        int count = stepValue['count'];
        String? imageUrl = stepValue['image'];

        //gap solution as somechecklist did not have this, remind me to remove
        if (stepValue['videocheck'] != null) {
          checkvideo = stepValue['videocheck'];
        }

        checklistintruct step = checklistintruct(
          description: description,
          count: count,
          media: imageUrl,
          isvideo: checkvideo,
        );

        //print(step.description.toString());

        steps.add(step);
      });
      steps.sort((a, b) => a.count.compareTo(b.count));

      // Create a Recipe object
      checklistclass recipe = checklistclass(
        name: name,
        description: steps,
        keyid: keyid,
      );

      export.add(recipe);
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

import 'package:firebase_database/firebase_database.dart';
import 'package:instructflow/classtypes/recipedata.dart';
import 'package:instructflow/classtypes/stepsrecipe.dart';

Future<List<List<Recipe>>> getRecipeDb() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('recipes').get();

  if (snapshot.exists) {
    var value = Map<String, dynamic>.from(snapshot.value as Map);
    List<Recipe> export = [];

    value.forEach((key, value) {
      String keyers = key;
      String uid = value['uid'].toString();
      String name = value['name'];
      Object stepper = value['steps'];
      String profilePicture = value['thumbnail'];

      var stepvalues = Map<String, dynamic>.from(stepper as Map);

      // Convert stepsData into a list of StepsRecipe objects
      List<StepsRecipe> steps = [];

      stepvalues.forEach((stepKey, stepValue) {
        int stepcount = stepValue['stepcount'];
        String description = stepValue['description'];
        String? imageUrl = stepValue['image_url'];
        bool videoUrl = stepValue['video_url'];

        StepsRecipe step = StepsRecipe(
          stepcount: stepcount,
          description: description,
          ImgUrl: imageUrl,
          isvid: videoUrl,
        );

        //print(step.description.toString());

        steps.add(step);
      });

      steps.sort((a, b) => a.stepcount.compareTo(b.stepcount));

      // Create a Recipe object
      Recipe recipe = Recipe(
        keyid: keyers,
        uniqid: uid,
        name: name,
        steps: steps,
        thumbnail: profilePicture,
      );

      export.add(recipe);
    });

    export.sort((a, b) => int.parse(a.uniqid).compareTo(int.parse(b.uniqid)));

    //print(export.toString());
    return [export];
  } else {
    // Handle the case where no data is available.
    // You can print a message or return an empty list as you did.
    // print('No data available.');
    return [];
  }
}

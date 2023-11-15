import 'package:instructflow/classtypes/stepsrecipe.dart';

class Recipe {
  late String uniqid;
  late String name;
  late List<StepsRecipe> steps;
  late String thumbnail;
  late String keyid;

  Recipe(
      {required this.uniqid,
      required this.name,
      required this.steps,
      required this.thumbnail,
      required this.keyid});
}

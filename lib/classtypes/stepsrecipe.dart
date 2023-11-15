class StepsRecipe {
  late int stepcount;
  late String description;
  String? ImgUrl;
  bool isvid;

  StepsRecipe({
    required this.stepcount,
    required this.description,
    this.ImgUrl,
     required this.isvid,
  });
}

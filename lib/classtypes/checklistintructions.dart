class checklistintruct {
  late String description;
  late int count;
  String? media;
  bool? isvideo;

  checklistintruct({
    required this.description,
    required this.count,
    this.media,
    this.isvideo,
  });
}

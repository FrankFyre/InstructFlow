class TaskClass {
  late String name;
  late String keyid;
  late String description;
  late String assigned;
  late bool isvideo;
  String? date;
  String? time;
  String mediaUrl;

  TaskClass({
    required this.name,
    required this.keyid,
    required this.description,
    required this.assigned,
    required this.mediaUrl,
    required this.isvideo,
    this.date,
    this.time,
  });
}

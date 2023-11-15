import 'package:instructflow/classtypes/checklistintructions.dart';

class checklistclass {
  late String name;
  late String keyid;
  late List<checklistintruct> description;

  checklistclass({
    required this.name,
    required this.keyid,
    required this.description,
  });
}

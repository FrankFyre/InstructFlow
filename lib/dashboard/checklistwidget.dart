import 'package:flutter/material.dart';
import 'package:instructflow/databaseUtils/dbloaders/checklistloader.dart';
import 'package:instructflow/classtypes/checklistclass.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:instructflow/dashboard/checklistexcution.dart';
import 'package:instructflow/managers/checklist/checklisteditor.dart';
import 'package:instructflow/services/texttospeech.dart';

class ChecklistWidget extends StatefulWidget {
  final String? employeename;
  final int stateroute;

  ChecklistWidget({this.employeename, required this.stateroute});
  @override
  State<ChecklistWidget> createState() => _ChecklistWidgetState();
}

class _ChecklistWidgetState extends State<ChecklistWidget> {
  Future<List<List<checklistclass>>> _checklistdata = Future.value([]);

  void initState() {
    super.initState();
    // Initialize the Future in initState
    _checklistdata = getChecklistDb();
  }

  //Push checklist select data to next page
  void _navigateTonextpage(checklist) {
    if (widget.stateroute == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => checklistexcution(
            check: checklist,
            employee:
                widget.employeename!, // Pass the employee name from the widget
          ),
        ),
      );
    } else if (widget.stateroute == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChecklistEditor(
            // Pass the employee name from the widget
            check: checklist,
          ),
        ),
      );
    }
  }

  List<Widget> generateWidgets(List<checklistclass> checklist) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    return checklist.map((checklist) {
      // Detect tap
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GestureDetector(
              onTap: () {
                _navigateTonextpage(checklist);
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(39, 52, 105, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  print(checklist.name);
                                  String currentText = checklist.name;
                                  TtsService ttsService = TtsService(
                                    ttsText: currentText,
                                  );
                                  ttsService.speak();
                                },
                                icon: const Icon(
                                  Icons.record_voice_over,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: isScreenWide ? 7 : 3,
                          child: Text(
                            checklist.name,
                            style: TextStyle(
                              fontSize: isScreenWide ? 40 : 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _navigateTonextpage(checklist);
                                },
                                icon: const Icon(
                                  Icons.question_mark,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))));
    }).toList();
  }

  Future<void> _refreshData() async {
    setState(() {
      _checklistdata = getChecklistDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<List<List<checklistclass>>>(
          future: _checklistdata,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(); // Show a loading indicator while data is being fetched
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final items =
                  snapshot.data?.expand((list) => list).toList() ?? [];
              return Container(
                height: 400,
                child: ResponsiveGridList(
                    horizontalGridSpacing:
                        16, // Horizontal space between grid items
                    verticalGridSpacing:
                        10, // Vertical space between grid items
                    horizontalGridMargin: 5, // Horizontal space around the grid
                    verticalGridMargin: 30, // Vertical space around the grid
                    minItemWidth:
                        300, // The minimum item width (can be smaller, if the layout constraints are smaller)
                    minItemsPerRow:
                        1, // The minimum items to show in a single row. Takes precedence over minItemWidth
                    maxItemsPerRow:
                        1, // The maximum items to show in a single row. Can be useful on large screens
                    // Options that are getting passed to the SliverChildBuilderDelegate() function
                    children: generateWidgets(items)),
              );
            }
          }),
    );
  }
}

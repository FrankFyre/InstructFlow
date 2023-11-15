import 'package:flutter/material.dart';
import 'package:instructflow/databaseUtils/dbloaders/tasklogs.dart';

import 'package:instructflow/classtypes/taskclass.dart';
import 'package:instructflow/databaseUtils/savetask.dart';

import 'package:responsive_grid_list/responsive_grid_list.dart';

class tasklog extends StatefulWidget {
  final int stateroute;

  tasklog({required this.stateroute});

  @override
  State<tasklog> createState() => _checklogState();
}

class _checklogState extends State<tasklog> {
  Future<List<List<TaskClass>>> _checklistdata = Future.value([]);
  bool? datetimer;

  @override
  void initState() {
    super.initState();
    // Initialize the Future in initState

    if (widget.stateroute == 1) {
      _checklistdata = getTaskdonelog();
      datetimer = true;
    } else if (widget.stateroute == 2) {
      _checklistdata = getTaskongoinglog();
      datetimer = false;
    }
  }

  List<Widget> generateWidgets(List<TaskClass> task) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    return task.map((task) {
      // Detect tap
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GestureDetector(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(" Delete task?"),
                    content: const Text("Confirm ?"),
                    actions: <Widget>[
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              child: const Icon(Icons.close),
                              onPressed: () {
                                // Close the dialog without performing any action.
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              child: const Icon(Icons.done),
                              onPressed: () async {
                                // Perform the action when "Yes" is clicked.
                                // You can call your function here.
                                await FirebaseUtils.deleteOnGoingTask(
                                    task.keyid, context);

                                Navigator.of(context).pop();
                                // Close the dialog.
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              );
            },
            child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(39, 52, 105, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${task.assigned}',
                        style: TextStyle(
                          fontSize: isScreenWide ? 26 : 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Task: ${task.name}',
                        style: TextStyle(
                          fontSize: isScreenWide ? 26 : 20,
                          color: Colors.white,
                        ),
                      ),
                      datetimer!
                          ? Text(
                              'Date: ${task.date}',
                              style: TextStyle(
                                fontSize: isScreenWide ? 26 : 20,
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      datetimer!
                          ? Text(
                              'Time: ${task.time}',
                              style: TextStyle(
                                fontSize: isScreenWide ? 26 : 20,
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                    ],
                  ),
                )),
          ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<TaskClass>>>(
        future: _checklistdata,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(); // Show a loading indicator while data is being fetched
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final items = snapshot.data?.expand((list) => list).toList() ?? [];
            return ResponsiveGridList(
                horizontalGridSpacing:
                    16, // Horizontal space between grid items
                verticalGridSpacing: 10, // Vertical space between grid items
                horizontalGridMargin: 30, // Horizontal space around the grid
                verticalGridMargin: 30, // Vertical space around the grid
                minItemWidth:
                    300, // The minimum item width (can be smaller, if the layout constraints are smaller)
                minItemsPerRow:
                    1, // The minimum items to show in a single row. Takes precedence over minItemWidth
                maxItemsPerRow:
                    1, // The maximum items to show in a single row. Can be useful on large screens
                // Options that are getting passed to the SliverChildBuilderDelegate() function
                children: generateWidgets(items));
          }
        });
  }
}

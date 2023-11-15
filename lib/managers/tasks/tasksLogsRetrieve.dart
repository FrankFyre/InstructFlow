import 'package:flutter/material.dart';
import 'package:instructflow/databaseUtils/dbloaders/tasklogs.dart';
import 'package:instructflow/classtypes/taskclass.dart';

import 'package:instructflow/databaseUtils/savetask.dart';

class TaskViewer extends StatefulWidget {
  final int stateroute;

  TaskViewer({required this.stateroute});

  @override
  State<TaskViewer> createState() => _TaskViewerState();
}

class _TaskViewerState extends State<TaskViewer> {
  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    var whereto;

    if (widget.stateroute == 1) {
      whereto = getTaskdonelog1();
    } else if (widget.stateroute == 2) {
      whereto = getTaskongoinglog1();
    }

    Future<void> _refreshData() async {
      if (widget.stateroute == 1) {
        setState(() {
          whereto = getTaskdonelog1();
        });
      } else if (widget.stateroute == 2) {
        setState(() {
          whereto = getTaskongoinglog1();
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<TaskClass>>(
          future: whereto,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Extract the sorted checklist logs
              List<TaskClass> logs = snapshot.data!;

              if (logs.isEmpty) {
                return const Center(child: Text('No ongoing tasks!'));
              } else {
                // Group the logs by date
                Map<String, List<TaskClass>> logsByDate = groupLogsByDate(logs);

                // Create a ListView to display the logs
                return ListView.builder(
                  itemCount: logsByDate.entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    var entry = logsByDate.entries.elementAt(index);
                    String date = entry.key;
                    List<TaskClass> logs = entry.value;

                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            date,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 73, 42, 42),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        for (int i = 0; i < logs.length; i++)
                          GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Unassign task?"),
                                    content: const Text("Confirm ?"),
                                    actions: <Widget>[
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
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
                                                await FirebaseUtils
                                                    .deleteOnGoingTask(
                                                        logs[i].keyid, context);

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
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: i == logs.length - 1 ? 8.0 : 1.0,
                                top: i == 0
                                    ? 8.0
                                    : 0, // Add top padding for the first item
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white60,
                                  // Apply different border decoration for the first and last items
                                  borderRadius: BorderRadius.vertical(
                                    top: i == 0
                                        ? const Radius.circular(20.0)
                                        : const Radius.circular(0),
                                    bottom: i == logs.length - 1
                                        ? const Radius.circular(20.0)
                                        : const Radius.circular(0),
                                  ),
                                ),
                                child: ListTile(
                                  leading: Text(
                                    '${logs[i].name} |',
                                    style: TextStyle(
                                        fontSize: isScreenWide ? 23 : 18),
                                  ),
                                  title: Text(
                                    '${logs[i].assigned}',
                                    style: TextStyle(
                                        fontSize: isScreenWide ? 23 : 18),
                                  ),
                                  trailing: SizedBox(
                                    width: 90,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.schedule),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text('${logs[i].time}')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }

  Map<String, List<TaskClass>> groupLogsByDate(List<TaskClass> logs) {
    Map<String, List<TaskClass>> groupedLogs = {};

    for (TaskClass log in logs) {
      String date = log.date!;

      if (!groupedLogs.containsKey(date)) {
        groupedLogs[date] = [];
      }

      groupedLogs[date]!.add(log);
    }

    return groupedLogs;
  }
}

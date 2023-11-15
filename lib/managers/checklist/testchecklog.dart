import 'package:flutter/material.dart';
import 'package:instructflow/databaseUtils/dbloaders/checklistlog.dart'; // Import the file where you defined getChecklistLogs
import 'package:instructflow/classtypes/checklogs.dart';

class ChecklistLogsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: FutureBuilder<List<checklistlogs>>(
          future: get2log(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Extract the sorted checklist logs
              List<checklistlogs> logs = snapshot.data!;

              if (logs.isEmpty) {
                return const Text('No checklist logs available.');
              } else {
                // Group the logs by date
                Map<String, List<checklistlogs>> logsByDate =
                    groupLogsByDate(logs);

                // Create a ListView to display the logs
                return ListView.builder(
                  itemCount: logsByDate.entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    var entry = logsByDate.entries.elementAt(index);
                    String date = entry.key;
                    List<checklistlogs> logs = entry.value;
                    logs.sort((b, a) => a.time.compareTo(b.time));

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
                          Padding(
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
                                  '${logs[i].employename}',
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

  Map<String, List<checklistlogs>> groupLogsByDate(List<checklistlogs> logs) {
    Map<String, List<checklistlogs>> groupedLogs = {};

    for (checklistlogs log in logs) {
      String date = log.date;

      if (!groupedLogs.containsKey(date)) {
        groupedLogs[date] = [];
      }

      groupedLogs[date]!.add(log);
    }

    return groupedLogs;
  }
}

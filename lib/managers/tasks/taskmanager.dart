// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:instructflow/managers/tasks/taskeditorselection.dart';
import 'package:instructflow/managers/tasks/taskcreator.dart';
import 'package:instructflow/managers/tasks/tasksLogsRetrieve.dart';
import 'package:instructflow/managers/tasks/assign/taskassign.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  bool b1 = true;
  bool b2 = false;
  bool b3 = false;
  bool b4 = false;
  bool b5 = false;

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          width: 2.0,
                          color: const Color.fromRGBO(242, 175, 41, 1)),
                      backgroundColor: b1
                          ? Color.fromRGBO(244, 219, 216, 1)
                          : Color.fromRGBO(242, 175, 41, 1),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                        b1 = true;
                        b4 = false;
                        b5 = false;
                      });
                    },
                    child: Text(
                      'Edit tasks',
                      style: TextStyle(
                        fontSize: isScreenWide ? 30 : 25,
                        color: b1
                            ? Color.fromARGB(255, 146, 146, 146)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          width: 2.0,
                          color: const Color.fromRGBO(242, 175, 41, 1)),
                      backgroundColor: b2
                          ? Color.fromRGBO(244, 219, 216, 1)
                          : Color.fromRGBO(242, 175, 41, 1),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TaskCreator(), // Navigate to RecipeCreator
                        ),
                      );
                    },
                    child: Text(
                      'Create task',
                      style: TextStyle(
                        fontSize: isScreenWide ? 30 : 25,
                        color: b2
                            ? Color.fromARGB(255, 146, 146, 146)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          width: 2.0,
                          color: const Color.fromRGBO(242, 175, 41, 1)),
                      backgroundColor: b2
                          ? Color.fromRGBO(244, 219, 216, 1)
                          : Color.fromRGBO(242, 175, 41, 1),
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TaskAssign(), // Navigate to RecipeCreator
                          ),
                        );
                      });
                    },
                    child: Text(
                      'Assign tasks',
                      style: TextStyle(
                        fontSize: isScreenWide ? 30 : 25,
                        color: b2
                            ? Color.fromARGB(255, 146, 146, 146)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          width: 2.0,
                          color: const Color.fromRGBO(242, 175, 41, 1)),
                      backgroundColor: b4
                          ? Color.fromRGBO(244, 219, 216, 1)
                          : Color.fromRGBO(242, 175, 41, 1),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                        b1 = false;
                        b4 = true;
                        b5 = false;
                      });
                    },
                    child: Text(
                      'Ongoing Task',
                      style: TextStyle(
                        fontSize: isScreenWide ? 30 : 25,
                        color: b4
                            ? Color.fromARGB(255, 146, 146, 146)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          width: 2.0,
                          color: const Color.fromRGBO(242, 175, 41, 1)),
                      backgroundColor: b5
                          ? Color.fromRGBO(244, 219, 216, 1)
                          : Color.fromRGBO(242, 175, 41, 1),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 3;
                        b1 = false;
                        b4 = false;
                        b5 = true;
                      });
                    },
                    child: Text(
                      'Completed Task',
                      style: TextStyle(
                        fontSize: isScreenWide ? 30 : 25,
                        color: b5
                            ? Color.fromARGB(255, 146, 146, 146)
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                tasktemplateview(),
                Center(
                  child: Text("Select Option ^"),
                ),
                TaskViewer(stateroute: 2),
                TaskViewer(stateroute: 1),
              ],
            ),
          )
        ],
      ),
    );
  }
}

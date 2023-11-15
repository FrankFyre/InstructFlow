// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instructflow/pages/employeeSelect.dart';

import 'package:instructflow/managers/checklist/checklistcreator.dart';
import 'package:instructflow/managers/checklist/testchecklog.dart';
import 'package:instructflow/dashboard/checklistwidget.dart';

class ChecklistManager extends StatefulWidget {
  const ChecklistManager({super.key});

  @override
  State<ChecklistManager> createState() => _ChecklistManagerState();
}

class _ChecklistManagerState extends State<ChecklistManager> {
  int _selectedIndex = 1;
  bool b1 = true;
  bool b2 = false;
  bool b3 = false;

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
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
                        _selectedIndex = 1;
                        b1 = true;
                        b2 = false;
                        b3 = false;
                      });
                    },
                    child: Text(
                      'View log',
                      style: TextStyle(
                        fontSize: isScreenWide ? 30 : 25,
                        color: b1
                            ? Color.fromARGB(255, 146, 146, 146)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
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
                        _selectedIndex = 2;
                        b1 = false;
                        b2 = true;
                        b3 = false;
                      });
                    },
                    child: Text(
                      'Edit Checklist',
                      style: TextStyle(
                        fontSize: isScreenWide ? 30 : 25,
                        color: b2
                            ? Color.fromARGB(255, 146, 146, 146)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          width: 2.0,
                          color: const Color.fromRGBO(242, 175, 41, 1)),
                      backgroundColor: b3
                          ? Color.fromRGBO(244, 219, 216, 1)
                          : Color.fromRGBO(242, 175, 41, 1),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChecklistCreator(), // Navigate to RecipeCreator
                        ),
                      );
                    },
                    child: Text(
                      'Create new',
                      style: TextStyle(
                        fontSize: isScreenWide ? 30 : 25,
                        color: b3
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
                Center(
                  child: Text("Select Option ^"),
                ),
                ChecklistLogsScreen(),
                ChecklistWidget(stateroute: 2),
                // Add your Daily Task widget here
                Container(
                  child: Center(
                    child: EmployeeSelect(stateroute: 2),

                    //child:dailyTaskWidget(employeename: name),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

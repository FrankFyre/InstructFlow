// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instructflow/pages/employeeSelect.dart';
import 'package:instructflow/managers/Employee/employeecreator.dart';

class EmployeeManager extends StatefulWidget {
  const EmployeeManager({super.key});

  @override
  State<EmployeeManager> createState() => _EmployeeManagerState();
}

class _EmployeeManagerState extends State<EmployeeManager> {
  int _selectedIndex = 1;
  bool b1 = true;
  bool b2 = false;

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
                      });
                    },
                    child: Text(
                      'Edit staff data',
                      style: TextStyle(
                        fontSize: isScreenWide ? 30 : 15,
                        color: b1
                            ? Color.fromARGB(255, 146, 146, 146)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: isScreenWide ? 50 : 20),
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
                              EmployeeCreator(), // Navigate to RecipeCreator
                        ),
                      );
                    },
                    child: Text(
                      'Add new staff',
                      style: TextStyle(
                        fontSize: isScreenWide ? 30 : 15,
                        color: b2
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

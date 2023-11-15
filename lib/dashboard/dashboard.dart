// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instructflow/classtypes/employeedata.dart';
import 'package:instructflow/dashboard/checklistwidget.dart';
import 'package:instructflow/dashboard/dailytaskwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EmployeDash extends StatefulWidget {
  final Employee employee;

  EmployeDash({required this.employee});

  @override
  _EmployeDashState createState() => _EmployeDashState();
}

class _EmployeDashState extends State<EmployeDash> {
  int _selectedIndex = 0;
  String dropdown = 'gb_en';

  bool b1 = true;
  bool b2 = false;

  Widget getMediaWidget(String? link) {
    if (link != null) {
      return CachedNetworkImage(
        imageUrl: link,
        fit: BoxFit.cover,
        width: double.infinity,
        placeholder: (context, url) => LinearProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset("placeholder_image.png"),
      );
    } else {
      // Handle the case where 'link' is null, e.g., display a placeholder image or widget.
      return Center(
          child: Text("No image available",
              style: TextStyle(fontWeight: FontWeight.bold)));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    String name = widget.employee.name;
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 219, 216, 1),
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Color.fromRGBO(48, 52, 63, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          direction: isScreenWide ? Axis.horizontal : Axis.vertical,
          children: [
            Expanded(
              flex: isScreenWide ? 1 : 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: isScreenWide ? 250 : 170,
                    width: isScreenWide ? 250 : 170,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10000.0),
                        child: getMediaWidget(widget.employee.thumbnail)),
                  ),
                  SizedBox(
                    height: isScreenWide ? 30 : 0,
                  ),
                  isScreenWide
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.employee.name,
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 0,
                        ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  SizedBox(height: isScreenWide ? 70 : 20),
                  Row(
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
                            b2 = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10),
                          child: Text(
                            'Daily Task',
                            style: TextStyle(
                              fontSize: isScreenWide ? 45 : 25,
                              color: b1
                                  ? Color.fromARGB(255, 146, 146, 146)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
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
                            _selectedIndex = 1;
                            b1 = false;
                            b2 = true;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10),
                          child: Text(
                            'Checklist',
                            style: TextStyle(
                                fontSize: isScreenWide ? 45 : 25,
                                color: b2
                                    ? Color.fromARGB(255, 146, 146, 146)
                                    : Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: isScreenWide ? 40 : 0,
                  ),
                  IndexedStack(
                    index: _selectedIndex,
                    children: [
                      // Add your Daily Task widget here
                      Center(
                        child:
                            dailyTaskWidget(employeename: name, lang: dropdown),

                        //child:dailyTaskWidget(employeename: name),
                      ),

                      // Add your Checklist widget here
                      ChecklistWidget(employeename: name, stateroute: 1)
                    ],
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

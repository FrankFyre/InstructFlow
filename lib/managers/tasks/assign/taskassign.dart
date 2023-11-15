// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:instructflow/classtypes/taskclass.dart';
import 'package:instructflow/classtypes/employeedata.dart';
import 'package:instructflow/databaseUtils/savetask.dart';

import 'package:instructflow/managers/tasks/assign/taskgetter.dart';

import 'package:instructflow/managers/tasks/assign/employeegetter.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ignore: must_be_immutable
class TaskAssign extends StatefulWidget {
  Employee? employeename;
  TaskClass? task;

  TaskAssign({this.employeename, this.task});

  @override
  State<TaskAssign> createState() => _TaskAssignState();
}

class _TaskAssignState extends State<TaskAssign> {
  bool t1 = false;
  bool t2 = false;

  // Function to save the task assignment
  Future<void> saveTaskAssignment() async {
    await FirebaseUtils.addTaskToOngoingTasks(
      widget.employeename!.name,
      widget.task!,
      context,
    );
  }

  reset() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Task Assigned"),
          content: Text(
            "${widget.employeename?.name} assigned ${widget.task?.name}",
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Assign another task"),
              onPressed: () {
                // Close the dialog.
                Navigator.of(context).pop();
                setState(() {
                  t1 = false;
                  t2 = false;
                  widget.employeename!.name = '';
                  widget.task!.name = "";
                });
              },
            ),
            ElevatedButton(
              child: Text("Exit"),
              onPressed: () {
                // Close the dialog.
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double sssize = MediaQuery.of(context).size.width;
    bool isScreenWide = sssize >= 450;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    transform: GradientRotation(0.261799),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [
              Color.fromRGBO(19, 84, 122, 1),
              Color.fromRGBO(128, 208, 199, 1),
            ],
                    stops: const [
              0,
              1
            ]))),
        title: Text('Assign'),
        actions: [
          // Save button in the app bar
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Show a confirmation dialog before saving
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirm Save"),
                    content: Text(
                      "Do you want to save the task assignment?",
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          // Close the dialog without performing any action.
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text("Save"),
                        onPressed: () {
                          // Perform the save action and close the dialog.
                          saveTaskAssignment();
                          Navigator.of(context).pop();
                          reset();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          // Shadow color
          gradient: RadialGradient(
            radius: 2.5,
            center: Alignment(0, 1),
            colors: const [
              Color.fromRGBO(244, 219, 216, 1),
              Color.fromRGBO(250, 128, 115, 1),
            ],
            stops: const [0, 0.99],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 9,
                  child: Flex(
                    direction: isScreenWide ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 0,
                                style: BorderStyle.solid),
                            borderRadius:
                                BorderRadius.circular(10), // Shadow color

                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(223, 114, 102, 1),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(
                                    250, 128, 115, 1), // Shadow color
                                // Offset to control the position of the shadow
                                blurRadius: 10, // Spread o the shadow
                                spreadRadius:
                                    -10, // Negative value for inset shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(242, 175, 41, 1)),
                                onPressed: () async {
                                  final finalltask = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => displaytask(),
                                    ),
                                  );
                                  // Handle the result returned from SecondPage

                                  setState(() {
                                    t2 = true;
                                    widget.task = finalltask;
                                  });
                                },
                                child: Text('Assign Tasks'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                widget.task?.name ?? '',
                                style: TextStyle(
                                  fontSize: isScreenWide ? 25 : 16,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  children: [
                                    t2
                                        ? SizedBox(
                                            height: sssize * 0.4,
                                            width: sssize * 0.4,
                                            child: CachedNetworkImage(
                                              imageUrl: widget.task!.mediaUrl,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  LinearProgressIndicator(),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      "placeholder_image.png"),
                                            ),
                                          )
                                        : Text(
                                            'Please select a task',
                                            style: TextStyle(
                                              fontSize: isScreenWide ? 25 : 16,
                                              color: Color.fromARGB(
                                                  255, 212, 35, 35),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                        height: 15,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 0,
                                style: BorderStyle.solid),
                            borderRadius:
                                BorderRadius.circular(10), // Shadow color

                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(223, 114, 102, 1),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(
                                    250, 128, 115, 1), // Shadow color
                                // Offset to control the position of the shadow
                                blurRadius: 10, // Spread o the shadow
                                spreadRadius:
                                    -10, // Negative value for inset shadow
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(242, 175, 41, 1)),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AssignEmployeeSelector(),
                                    ),
                                  );
                                  // Handle the result returned from SecondPage

                                  setState(() {
                                    t1 = true;
                                    widget.employeename = result;
                                  });
                                },
                                child: Text('Emplyoyee'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                widget.employeename?.name ?? '',
                                style: TextStyle(
                                  fontSize: isScreenWide ? 25 : 16,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  children: [
                                    // Image for tasks or "Select" text
                                    t1
                                        ? SizedBox(
                                            height: sssize * 0.4,
                                            width: sssize * 0.4,
                                            child: CachedNetworkImage(
                                              imageUrl: widget
                                                  .employeename!.thumbnail,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  LinearProgressIndicator(),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      "placeholder_image.png"),
                                            ),
                                          )
                                        : Text(
                                            'Please select an employee',
                                            style: TextStyle(
                                              fontSize: isScreenWide ? 25 : 16,
                                              color: Color.fromARGB(
                                                  255, 212, 35, 35),
                                            ),
                                          ),
                                    // Name for tasks
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: t1 && t2
                        ? GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Save"),
                                    content: Text(
                                      "Do you want to save the task assignment?",
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          // Close the dialog without performing any action.
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text("Save"),
                                        onPressed: () {
                                          // Perform the save action and close the dialog.
                                          saveTaskAssignment();
                                          Navigator.of(context).pop();
                                          reset();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ); // Pop the current page
                            },
                            child: Card(
                                color: Color.fromRGBO(39, 52, 105, 1),
                                child: Center(
                                    child: Text(
                                  'Assign and save',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ))),
                          )
                        : Text(""))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

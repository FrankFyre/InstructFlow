import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:instructflow/databaseUtils/dbloaders/taskloader.dart';
import 'package:instructflow/classtypes/taskclass.dart';
import 'package:instructflow/services/texttospeech.dart';
import 'package:instructflow/dashboard/taskExecution.dart';
import 'package:instructflow/databaseUtils/logcheckdb.dart';

class dailyTaskWidget extends StatefulWidget {
  final String employeename;
  final int? stateroute;
  final String lang;

  dailyTaskWidget(
      {this.stateroute, required this.employeename, required this.lang});

  @override
  State<dailyTaskWidget> createState() => _dailyTaskWidgetState();
}

class _dailyTaskWidgetState extends State<dailyTaskWidget> {
  Future<List<List<TaskClass>>> _taskdata = Future.value([]);

  @override
  void initState() {
    super.initState();
    // Initialize the Future in initState

    if (widget.stateroute == 1) {
      _taskdata = getTask();
    } else {
      _taskdata = cehckemployeetaskdb(widget.employeename);
    }
  }

  void _navigateTonextpage(TaskClass task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => taskexpanded(
          task: task,
          employee: widget.employeename,
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    if (widget.stateroute == 1) {
      setState(() {
        _taskdata = getTask();
      });
    } else {
      setState(() {
        _taskdata = cehckemployeetaskdb(widget.employeename);
      });
    }
  }

  List<Widget> generateWidgets(List<TaskClass> tasks) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    return tasks.map((task) {
      // Detect tap
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GestureDetector(
              onTap: () {
                _navigateTonextpage(task);
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
                                  String currentText = task.name;
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
                            task.name,
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
                                  _navigateTonextpage(task);
                                },
                                icon: const Icon(
                                  Icons.question_mark,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Update task status"),
                                        content: const Text(
                                            "Have you completed the task ?"),
                                        actions: <Widget>[
                                          Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  child:
                                                      const Icon(Icons.close),
                                                  onPressed: () {
                                                    // Close the dialog without performing any action.
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ElevatedButton(
                                                  child: const Icon(Icons.done),
                                                  onPressed: () {
                                                    FirebaseService()
                                                        .deleteAndMoveTaskToCompleted(
                                                            task.keyid);

                                                    Navigator.of(context).pop();
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
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ))));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<List<TaskClass>>>(
          future: _taskdata,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(); // Show a loading indicator while data is being fetched
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final tasks =
                  snapshot.data?.expand((list) => list).toList() ?? [];
              return Container(
                height: 400,
                child: ResponsiveGridList(
                  horizontalGridSpacing: 16,
                  verticalGridSpacing: 10,
                  horizontalGridMargin: 5,
                  verticalGridMargin: 30,
                  minItemWidth: 300,
                  minItemsPerRow: 1,
                  maxItemsPerRow: 1,
                  children: generateWidgets(tasks),
                ),
              );
            }
          },
        ));
  }
}

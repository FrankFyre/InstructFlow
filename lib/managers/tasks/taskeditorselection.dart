import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import 'package:instructflow/databaseUtils/dbloaders/taskloader.dart';
import 'package:instructflow/classtypes/taskclass.dart';

import 'package:instructflow/managers/tasks/taskeditor.dart';

class tasktemplateview extends StatefulWidget {
  @override
  State<tasktemplateview> createState() => _tasktemplateviewState();
}

class _tasktemplateviewState extends State<tasktemplateview> {
  Future<List<List<TaskClass>>> _taskdata = Future.value([]);

  void initState() {
    super.initState();
    _taskdata = getTask();
  }

  //Push recipe select data to next page
  void _navigateTonextpage(recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskEditor(task: recipe)),
    );
  }

  List<Widget> generateWidgets(List<TaskClass> recipes) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    return recipes.map((recipe) {
      // Detect tap
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GestureDetector(
              onTap: () {
                _navigateTonextpage(recipe);
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
                        Text(
                          recipe.name,
                          style: TextStyle(
                            fontSize: isScreenWide ? 26 : 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ))));
    }).toList();
  }

  Future<void> _refreshData() async {
    setState(() {
      _taskdata = getTask();
    });
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
              final items =
                  snapshot.data?.expand((list) => list).toList() ?? [];
              return ResponsiveGridList(
                  horizontalGridSpacing:
                      16, // Horizontal space between grid items
                  verticalGridSpacing:
                      10, // Vertical space between grid items
                  horizontalGridMargin:
                      30, // Horizontal space around the grid
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
          }),
    );
  }
}

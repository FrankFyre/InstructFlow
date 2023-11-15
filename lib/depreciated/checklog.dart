import 'package:flutter/material.dart';
import 'package:instructflow/databaseUtils/dbloaders/checklistlog.dart';
import 'package:instructflow/classtypes/checklogs.dart';

import 'package:responsive_grid_list/responsive_grid_list.dart';

class checklog extends StatefulWidget {
  @override
  State<checklog> createState() => _checklogState();
}

class _checklogState extends State<checklog> {
  Future<List<List<checklistlogs>>> _checklistdata = Future.value([]);

  void initState() {
    super.initState();
    // Initialize the Future in initState
    _checklistdata = getChecklistlog();
  }

  List<Widget> generateWidgets(List<checklistlogs> recipes) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    return recipes.map((recipe) {
      // Detect tap
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(39, 52, 105, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${recipe.employename}',
                      style: TextStyle(
                        fontSize: isScreenWide ? 26 : 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Type: ${recipe.name}',
                      style: TextStyle(
                        fontSize: isScreenWide ? 26 : 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Date: ${recipe.date}',
                      style: TextStyle(
                        fontSize: isScreenWide ? 26 : 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Time: ${recipe.time}',
                      style: TextStyle(
                        fontSize: isScreenWide ? 26 : 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<checklistlogs>>>(
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

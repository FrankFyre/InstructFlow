import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:instructflow/databaseUtils/dbloaders/taskloader.dart';
import 'package:instructflow/classtypes/taskclass.dart';
import 'package:cached_network_image/cached_network_image.dart';

class displaytask extends StatefulWidget {
  @override
  State<displaytask> createState() => _displaytaskState();
}

class _displaytaskState extends State<displaytask> {
  Future<List<List<TaskClass>>> _checklistdata = Future.value([]);

  void initState() {
    super.initState();
    // Initialize the Future in initState
    _checklistdata = getTask();
  }

  void _navigateToNextPage(TaskClass task) {
    Navigator.pop(context, task);
  }

  List<Widget> generateWidgets(List<TaskClass> recipes) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    return recipes.map((recipe) {
      // Detect tap
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GestureDetector(
            onTap: () {
              _navigateToNextPage(recipe);
            },
            child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(39, 52, 105, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: recipe.isvideo
                            ? const Text("Preview now available")
                            : SizedBox(
                                height: 200,
                                child: CachedNetworkImage(
                                  imageUrl: recipe.mediaUrl,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset("placeholder_image.png"),
                                ),
                              ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'recipe.name',
                                style: TextStyle(
                                  fontSize: isScreenWide ? 30 : 20,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: isScreenWide ? 30 : 20,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                recipe.description.length > 80
                                    ? recipe.description.substring(0, 80) +
                                        '...'
                                    : recipe.description,
                                style: TextStyle(
                                  fontSize: isScreenWide ? 30 : 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<List<TaskClass>>>(
          future: _checklistdata,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(); // Show a loading indicator while data is being fetched
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final items =
                  snapshot.data?.expand((list) => list).toList() ?? [];
              return Container(
                decoration: const BoxDecoration(
                  // Shadow color
                  gradient: RadialGradient(
                    radius: 2.5,
                    center: Alignment(0, 1),
                    colors: [
                      Color.fromRGBO(244, 219, 216, 1),
                      Color.fromRGBO(250, 128, 115, 1),
                    ],
                    stops: [0, 0.99],
                  ),
                ),
                child: ResponsiveGridList(
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
                    children: generateWidgets(items)),
              );
            }
          }),
    );
  }
}

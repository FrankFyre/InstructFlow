// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:instructflow/classtypes/employeedata.dart';
import 'package:instructflow/databaseUtils/dbloaders/employeeloader.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:responsive_grid_list/responsive_grid_list.dart';

class AssignEmployeeSelector extends StatefulWidget {
  @override
  State<AssignEmployeeSelector> createState() => _AssignEmployeeSelectorState();
}

class _AssignEmployeeSelectorState extends State<AssignEmployeeSelector> {
  Future<List<List<Employee>>> _employeeData = Future.value([]);

  @override
  void initState() {
    super.initState();
    // Initialize the Future in initState
    _employeeData = getEmployeeDb();
  }

  Future<String> getImageUrl(String filename) async {
    String imagePath =
        "Employee/$filename"; // Replace with the actual path to your image
    final storageRef = FirebaseStorage.instance.ref().child(imagePath);

    try {
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      // Handle any errors that may occur during URL retrieval
      print("Error getting download URL: $e");
      return "";
    }
  }

  _navigatePage(Employee employee) {
    Navigator.pop(context, employee);
  }

  List<Widget> generateRecipeWidgets(List<Employee> recipes) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;

    int largefont = 10;
    int smallFont = 10;

    return recipes.map((recipe) {
      // Detect tap
      return GestureDetector(
        onTap: () {
          _navigatePage(recipe);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            //color: const Color.fromRGBO(39, 52, 105, 1),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(4, 4)),
              ],
              border: Border.all(
                  color: Colors.black, width: 0, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(242, 175, 41, 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: isScreenWide
                        ? 4 / 3
                        : 4 / 3, // Set the desired aspect ratio
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: recipe.thumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) =>
                            LinearProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset("placeholder_image.png"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
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
                                  color: Color.fromRGBO(199, 134, 6, 1),
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(
                                      242, 175, 41, 1), // Shadow color
                                  // Offset to control the position of the shadow
                                  blurRadius: 20, // Spread o the shadow
                                  spreadRadius:
                                      -10, // Negative value for inset shadow
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                recipe.uniqid,
                                style: TextStyle(
                                    fontSize: isScreenWide ? 30 : 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 3,
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
                                  color: Color.fromRGBO(199, 134, 6, 1),
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(
                                      242, 175, 41, 1), // Shadow color
                                  // Offset to control the position of the shadow
                                  blurRadius: 20, // Spread o the shadow
                                  spreadRadius:
                                      -10, // Negative value for inset shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: isScreenWide
                                  ? EdgeInsets.fromLTRB(20, 0, 0, 0)
                                  : EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                recipe.name,
                                style: TextStyle(
                                    fontSize: isScreenWide ? 30 : 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    return FutureBuilder<List<List<Employee>>>(
        future: _employeeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator(); // Show a loading indicator while data is being fetched
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final employees =
                snapshot.data?.expand((list) => list).toList() ?? [];
            return Container(
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
              child: ResponsiveGridList(
                  horizontalGridSpacing:
                      16, // Horizontal space between grid items
                  verticalGridSpacing: 10, // Vertical space between grid items
                  horizontalGridMargin: 30, // Horizontal space around the grid
                  verticalGridMargin: 30, // Vertical space around the grid
                  minItemWidth: isScreenWide
                      ? 300
                      : 150, // The minimum item width (can be smaller, if the layout constraints are smaller)
                  minItemsPerRow:
                      1, // The minimum items to show in a single row. Takes precedence over minItemWidth
                  maxItemsPerRow:
                      5, // The maximum items to show in a single row. Can be useful on large screens
                  // Options that are getting passed to the SliverChildBuilderDelegate() function
                  children: generateRecipeWidgets(employees)),
            );
          }
        });
  }
}

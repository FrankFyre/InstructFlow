import 'package:flutter/material.dart';

import 'package:instructflow/classtypes/recipedata.dart';
import 'package:instructflow/pages/recipenav.dart';
import 'package:instructflow/databaseUtils/dbloaders/recipeloader.dart';
import 'package:instructflow/managers/recipe/recipeeditor.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:responsive_grid_list/responsive_grid_list.dart';

class RecipeSelect extends StatefulWidget {
  final int stateroute;

  RecipeSelect({required this.stateroute});

  @override
  State<RecipeSelect> createState() => _RecipeSelectState();
}

class _RecipeSelectState extends State<RecipeSelect> {
  Future<List<List<Recipe>>> _RecipeData = Future.value([]);

  @override
  void initState() {
    super.initState();
    //Initialize the Future in initState
    _RecipeData = getRecipeDb();
  }

  //Push recipe select data to next page
  void _navigateToRecipeDetail(Recipe recipe) {
    if (widget.stateroute == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RecipeStepPage(recipe: recipe), // Pass the selected recipe here
        ),
      );
    } else if (widget.stateroute == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RecipeEditor(recipe: recipe), // Pass the selected recipe here
        ),
      );
    }
  }

  List<Widget> generateRecipeWidgets(List<Recipe> recipes) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    return recipes.map((recipe) {
      // Detect tap
      return GestureDetector(
        onTap: () {
          _navigateToRecipeDetail(recipe);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            //color: const Color.fromRGBO(39, 52, 105, 1),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(59, 0, 0, 0),
                    blurRadius: 5,
                    spreadRadius: 3,
                    offset: Offset(4, 4)),
              ],
              border: Border.all(
                  color: Colors.black, width: 0, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(39, 52, 105, 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: isScreenWide
                        ? 4 / 3
                        : 4 / 2, // Set the desired aspect ratio
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
                            const LinearProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset("placeholder_image.png"),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
                                  color: Color.fromRGBO(22, 29, 54, 1),
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(
                                      30, 39, 73, 1), // Shadow color
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
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
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
                                  color: Color.fromRGBO(22, 29, 54, 1),
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(
                                      30, 39, 73, 1), // Shadow color
                                  // Offset to control the position of the shadow
                                  blurRadius: 20, // Spread o the shadow
                                  spreadRadius:
                                      -10, // Negative value for inset shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text(
                                recipe.name,
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.white),
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

  Future<void> _refreshData() async {
    setState(() {
      _RecipeData = getRecipeDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<List<List<Recipe>>>(
          future: _RecipeData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(); // Show a loading indicator while data is being fetched
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final recipes =
                  snapshot.data?.expand((list) => list).toList() ?? [];
              return ResponsiveGridList(
                  horizontalGridSpacing:
                      16, // Horizontal space between grid items
                  verticalGridSpacing: 16, // Vertical space between grid items
                  horizontalGridMargin: 30, // Horizontal space around the grid
                  verticalGridMargin: 30, // Vertical space around the grid
                  minItemWidth:
                      300, // The minimum item width (can be smaller, if the layout constraints are smaller)
                  minItemsPerRow:
                      1, // The minimum items to show in a single row. Takes precedence over minItemWidth
                  maxItemsPerRow:
                      5, // The maximum items to show in a single row. Can be useful on large screens
                  // Options that are getting passed to the SliverChildBuilderDelegate() function
                  children: generateRecipeWidgets(recipes));
            }
          }),
    );
  }
}

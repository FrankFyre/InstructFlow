// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instructflow/pages/recipeSelect.dart';
import 'package:instructflow/managers/recipe/recipecreator.dart';

class recipemanager extends StatefulWidget {
  const recipemanager({super.key});

  @override
  State<recipemanager> createState() => _recipemanagerState();
}

class _recipemanagerState extends State<recipemanager> {
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
                    'Edit recipe',
                    style: TextStyle(
                      fontSize: isScreenWide ? 30 : 25,
                      color: b1
                          ? Color.fromARGB(255, 146, 146, 146)
                          : Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: isScreenWide ? 50 : 10),
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
                            RecipeCreator(), // Navigate to RecipeCreator
                      ),
                    );
                  },
                  child: Text(
                    'Create Recipe',
                    style: TextStyle(
                      fontSize: isScreenWide ? 30 : 25,
                      color: b2
                          ? Color.fromARGB(255, 146, 146, 146)
                          : Colors.white,
                    ),
                  ),
                ),
              ],
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
                    child: RecipeSelect(stateroute: 2),

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

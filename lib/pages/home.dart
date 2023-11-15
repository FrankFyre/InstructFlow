// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instructflow/pages/recipeSelect.dart';

import 'package:instructflow/pages/employeeSelect.dart';
import 'package:instructflow/pages/manage.dart';

import 'package:dot_navigation_bar/dot_navigation_bar.dart';

import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:instructflow/services/nav_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  String title = "Recipe";

  final List<Widget> _widgetOptions = [
    RecipeSelect(stateroute: 1),
    EmployeeSelect(stateroute: 1),
    manage(),
  ];

  List<CollapsibleItem> get _items {
    return [
      CollapsibleItem(
        text: 'Recipe',
        icon: myicon.recipe_knife,
        onPressed: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
      CollapsibleItem(
        text: 'Dashboard',
        icon: myicon.dashboard_knife,
        onPressed: () {
          setState(() {
            _selectedIndex = 1;
          });
        },
      ),
      CollapsibleItem(
        text: 'Manager',
        icon: myicon.manager_knife,
        onPressed: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      CollapsibleItem(
        text: '',
        isSelected: true,
        onPressed: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
    ];
  }

  CustomBody() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: _widgetOptions.elementAt(_selectedIndex));
  }

  //  LinearGradient(
  //           transform: GradientRotation(106.5),
  //           colors: const [
  //             Color.fromRGBO(255, 215, 185, 0.91),
  //             Color.fromRGBO(223, 159, 247, 0.8),
  //           ],
  //           stops: const [0.23, 0.92],
  //         )

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    // backgroundColor: Color.fromRGBO(244, 219, 216, 1),
    // extendBody: true,

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          // Shadow color
          gradient: RadialGradient(
            radius: 2.5,
            center: Alignment(0, 1),
            colors: const [
              Color.fromRGBO(244, 219, 216, 1),
              Color.fromRGBO(250, 128, 115, 1),
            ],
            stops: const [0, 0.5],
          ),
        ),
        child: Scaffold(
            backgroundColor: Color.fromRGBO(244, 219, 216, 0),
            extendBody: true,
            body: isScreenWide
                ? CollapsibleSidebar(
                    showTitle: false,
                    backgroundColor: Color.fromRGBO(30, 39, 73, 1),
                    unselectedIconColor: Colors.white,
                    selectedIconColor: Colors.red,
                    items: _items,
                    body: CustomBody(),
                    sidebarBoxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(30, 39, 73, 1),
                          blurRadius: 10,
                          spreadRadius: 0.01,
                          offset: Offset(3, 3),
                        ),
                      ])
                : CustomBody(),
            bottomNavigationBar: isScreenWide
                ? null
                : DotNavigationBar(
                    backgroundColor: Color.fromRGBO(30, 39, 73, 1),
                    currentIndex: _selectedIndex,
                    borderRadius: 10,
                    onTap: (value) {
                      setState(() {
                        _selectedIndex = value;
                      });
                    },
                    // dotIndicatorColor: Colors.black,
                    items: [
                      /// Home
                      DotNavigationBarItem(
                        icon: Icon(
                          myicon.recipe_knife,
                          color: Colors.white,
                        ),
                        selectedColor: Colors.green,
                      ),

                      /// Likes
                      DotNavigationBarItem(
                        icon: Icon(
                          myicon.dashboard_knife,
                          color: Colors.white,
                        ),
                        selectedColor: Colors.pink,
                      ),

                      /// Search
                      DotNavigationBarItem(
                        icon: Icon(
                          myicon.manager_knife,
                          color: Colors.white,
                        ),
                        selectedColor: Colors.orange,
                      ),

                      /// Profile
                    ],
                  )),
      ),
    );
  }
}

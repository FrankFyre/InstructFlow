// ignore_for_file: prefer_const_constructors, unused_field

import 'package:flutter/material.dart';

import 'package:instructflow/managers/recipe/recipemanager.dart';
import 'package:instructflow/managers/Employee/employeemanager.dart';
import 'package:instructflow/managers/checklist/checklistmanager.dart';
import 'package:instructflow/managers/tasks/taskmanager.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class manage extends StatefulWidget {
  const manage({super.key});

  @override
  State<manage> createState() => _manageState();
}

class _manageState extends State<manage> {
  int _selectedIndex = 0;
  int _selectedtitle = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TaskManager(),
    ChecklistManager(),
    recipemanager(),
    EmployeeManager(),
  ];

  static const List namesTitle = [
    "Tasks Manager",
    "Checklist Manager",
    "Recipe Manager",
    "Employee Manager",
  ];

  late String title;

  @override
  void initState() {
    title = "Home";
    super.initState();
  }

  int _counter = 0;
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SliderDrawer(
      key: _sliderDrawerKey,
      appBar: SliderAppBar(
          appBarColor: Color.fromRGBO(250, 128, 115, 1),
          title: Text(namesTitle[_selectedtitle],
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(28, 51, 39, 1),
              ))),
      slider: _SliderView(
        onItemClick: (value) {
          _sliderDrawerKey.currentState!.closeSlider();

          setState(() {
            _counter = int.parse(value);
            _selectedtitle = int.parse(value);
          });
        },
      ),
      slideDirection: SlideDirection.RIGHT_TO_LEFT,
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
          child: _widgetOptions[_counter]),
    ));
  }
}

class _SliderView extends StatelessWidget {
  final Function(String)? onItemClick;

  const _SliderView({Key? key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // Shadow color
          color: Color.fromRGBO(39, 52, 105, 1)),
      padding: const EdgeInsets.only(top: 30),
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          CircleAvatar(
            radius: 65,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/neelix.PNG'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Neelix Cafe',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Manager Dashboard',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ...[
            Menu(Icons.ballot, 'Task', 0),
            Menu(Icons.task, 'Checklist', 1),
            Menu(Icons.outdoor_grill, 'Recipes', 2),
            Menu(Icons.badge, 'Employee', 3),
          ]
              .map((menu) => _SliderMenuItem(
                    cc: menu,
                    title: menu.title,
                    iconData: menu.iconData,
                    onTap: onItemClick,
                  ))
              .toList(),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final Menu cc;

  final IconData iconData;
  final Function(String)? onTap;

  const _SliderMenuItem({
    Key? key,
    required this.title,
    required this.cc,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(
              color: Colors.white, fontFamily: 'BalsamiqSans_Regular')),
      leading: Icon(iconData, color: Color.fromRGBO(242, 175, 41, 1)),
      onTap: () => onTap?.call(cc.value.toString()),
    );
  }
}

class Menu {
  final IconData iconData;
  final String title;
  final int value;

  Menu(
    this.iconData,
    this.title,
    this.value,
  );
}

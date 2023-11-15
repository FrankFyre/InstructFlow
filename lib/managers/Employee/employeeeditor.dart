// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instructflow/classtypes/employeedata.dart';
import 'package:instructflow/databaseUtils/savemployee.dart';

import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EmployeeEditor extends StatefulWidget {
  final Employee employee;

  EmployeeEditor({required this.employee});

  @override
  _EmployeeEditorState createState() => _EmployeeEditorState();
}

class _EmployeeEditorState extends State<EmployeeEditor> {
  late TextEditingController nameController;
  late String menuid;
  late String keyid;
  late String thumbnailOG;
  File? thumbnailnew;
  late bool newthumbcheck;

  List<dynamic> selectimageurl = [];
  List<dynamic> originalimageurl = []; // Initialize as an empty list

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee.name);
    menuid = widget.employee.uniqid;
    keyid = widget.employee.keyid;
    thumbnailOG = widget.employee.thumbnail;
    newthumbcheck = false;
  }

  Future<void> updateEmployee(context) async {
    await FirebaseUtils.saveEmployeeToFirebase(
        widget.employee, nameController.text, context, keyid);

    setState(() {
      widget.employee.name = nameController.text;
    });
  }

  Future<void> saveGetStorageUrls() async {
    if (thumbnailnew != null) {
      widget.employee.thumbnail =
          await FirebaseUtils.uploadImageToStorage(thumbnailnew!);
    }
  }

  Future<void> _pickimggallery(int index, int loop) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        newthumbcheck = true;
        thumbnailnew = File(image.path);
      });
    }
  }

  Future<void> _pickimgcamera(int index, int loop) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        newthumbcheck = true;
        thumbnailnew = File(image.path);
      });
    }
  }

  void pushback(context) {
    Navigator.of(context).pop();
  }

  Widget getterthumnail() {
    if (newthumbcheck == false) {
      return CachedNetworkImage(
        imageUrl: thumbnailOG,
        placeholder: (context, url) => LinearProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset("placeholder_image.png"),
      );
    } else if (newthumbcheck == true) {
      return Image.file(thumbnailnew!);
    } else {
      return Text('Please Upload image');
    }
  }

  progresindi() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Saving"),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LoadingAnimationWidget.newtonCradle(
                    color: Color.fromRGBO(242, 175, 41, 1),
                    size: 200,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    stops: [
              0,
              1
            ]))),
        title: Text('Edit employee details'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Save new employee"),
                    content: Text("Confirm ?"),
                    actions: <Widget>[
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              child: Icon(Icons.close),
                              onPressed: () {
                                // Close the dialog without performing any action.
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              child: Icon(Icons.done),
                              onPressed: () async {
                                progresindi();

                                await saveGetStorageUrls();
                                await updateEmployee(context);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
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
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(" Delete employee information?"),
                    content: Text("Confirm ?"),
                    actions: <Widget>[
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              child: Icon(Icons.close),
                              onPressed: () {
                                // Close the dialog without performing any action.
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              child: Icon(Icons.done),
                              onPressed: () async {
                                // Perform the action when "Yes" is clicked.
                                // You can call your function here.
                                FirebaseUtils.deleteEmployee(
                                    keyid, thumbnailOG, context);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                // Close the dialog.
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Thumbnail Image',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(height: 200, child: getterthumnail()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(242, 175, 41, 1)),
                                  onPressed: () {
                                    _pickimggallery(1, 2);
                                  },
                                  child: Text("Gallery"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(242, 175, 41, 1)),
                                  onPressed: () {
                                    _pickimgcamera(1, 2);
                                  },
                                  child: Text("Camera"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 40,
                          height: 40,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Staff Name',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Enter staff name',
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Staff id',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              initialValue: menuid.toString(),
                              onChanged: (value) {
                                menuid = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter Staff Id',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}

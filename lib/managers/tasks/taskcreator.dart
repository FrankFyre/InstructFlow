// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instructflow/classtypes/taskclass.dart';
import 'package:instructflow/databaseUtils/savetask.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:image_picker/image_picker.dart';

class TaskCreator extends StatefulWidget {
  @override
  _TaskCreatorState createState() => _TaskCreatorState();
}

class _TaskCreatorState extends State<TaskCreator> {
  late TextEditingController nameController;

  late String keyid;
  late String thumbnailOG;
  late String description;
  late bool isvideo;

  File? thumnuu;
  late bool thumbnail;
  late String upthumbnail;

  List<dynamic> selectimageurl = [];
  List<dynamic> originalimageurl = []; // Initialize as an empty list

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();

    description = '';
    thumbnail = false;
    upthumbnail = '';
    isvideo = false;
  }

  Future<void> updateTask(context) async {
    TaskClass task = TaskClass(
      name: nameController.text,
      keyid: '',
      description: description,
      assigned: '',
      mediaUrl: upthumbnail,
      isvideo: isvideo,
    );

    await FirebaseUtils.saveNewtaskToFirebase(
      task,
      nameController.text,
      context,
    );
  }

  Future<void> saveGetStorageUrls() async {
    if (thumbnail == true) {
      upthumbnail = await FirebaseUtils.uploadImageToStorage(thumnuu!, isvideo);
      setState(() {
        upthumbnail;
      });
    }
  }

  Future<void> _pickimggallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        thumbnail = true;
        thumnuu = File(image.path);
        isvideo = false;
      });
    }
  }

  Future<void> _pickimgcamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        thumbnail = true;
        thumnuu = File(image.path);
        isvideo = false;
      });
    }
  }

  Future<void> videoPickGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? media = await picker.pickVideo(source: ImageSource.gallery);
    if (media != null) {
      setState(() {
        thumnuu = File(media.path);
        isvideo = true;
      });
    }
  }

  Future<void> videoPickCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? media = await picker.pickVideo(source: ImageSource.camera);
    if (media != null) {
      setState(() {
        thumnuu = File(media.path);
        isvideo = true;
      });
    }
  }

  Widget getterthumnail() {
    if (isvideo == true) {
      return Text("Video preview not avaible",
          style: (TextStyle(fontWeight: FontWeight.bold)));
    } else if (thumbnail == true) {
      return Image.file(thumnuu!);
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
        title: Text('Create Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Save new task ?"),
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
                                await updateTask(context);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .pop(); // Close the dialog.
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
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Chooing from gallery"),
                                        content: Text(
                                            "What type do you want to upload ?"),
                                        actions: <Widget>[
                                          Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Color.fromRGBO(30,
                                                                  39, 73, 1)),
                                                  onPressed: () {
                                                    _pickimggallery();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Image"),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Color.fromRGBO(30,
                                                                  39, 73, 1)),
                                                  onPressed: () {
                                                    videoPickGallery();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Video"),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text("Gallery"),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(242, 175, 41, 1)),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Choosing from gallery"),
                                        content: Text(
                                            "What type do you want to upload ?"),
                                        actions: <Widget>[
                                          Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Color.fromRGBO(30,
                                                                  39, 73, 1)),
                                                  onPressed: () {
                                                    _pickimgcamera();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Image"),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Color.fromRGBO(30,
                                                                  39, 73, 1)),
                                                  onPressed: () {
                                                    videoPickCamera();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Video"),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text("Camera"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Task Name',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'Enter task name',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Task description',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            maxLines: null,
                            initialValue: description,
                            onChanged: (value) {
                              description = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter task description',
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
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}

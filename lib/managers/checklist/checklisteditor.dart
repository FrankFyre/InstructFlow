// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:instructflow/databaseUtils/savechecklist.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instructflow/classtypes/checklistclass.dart';
import 'package:instructflow/classtypes/checklistintructions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChecklistEditor extends StatefulWidget {
  final checklistclass check;

  const ChecklistEditor({required this.check});

  @override
  _ChecklistEditorState createState() => _ChecklistEditorState();
}

class _ChecklistEditorState extends State<ChecklistEditor> {
  late TextEditingController nameController;
  late String keyid;

  late List<checklistintruct> steps;
  List<dynamic> selectimageurl = [];
  List<dynamic> originalimageurl = [];
  List<TextEditingController> descriptionControllers = [];

  List<dynamic> getImageUrls(steps) {
    List<dynamic> imageUrls = [];

    for (int index = 0; index < steps.length; index++) {
      if (steps[index].media != null) {
        selectimageurl.add(steps[index].media);
        originalimageurl.add(steps[index].media);
      } else {
        selectimageurl.add(null); // Add null for steps without an image URL
        originalimageurl.add(null);
      }
    }

    return imageUrls;
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.check.name);
    keyid = widget.check.keyid;
    steps = List.from(widget.check.description);
    getImageUrls(steps);
    for (int i = 0; i < steps.length; i++) {
      descriptionControllers
          .add(TextEditingController(text: steps[i].description));
    }
  }

  Future<void> updateRecipe() async {
    await FirebaseUtils.saveCheckToFirebase(
      widget.check,
      nameController.text,
      keyid,
      steps,
      context,
    );

    setState(() {
      widget.check.name = nameController.text;
      widget.check.description = List.from(steps);
    });
  }

  void _addStep() {
    setState(() {
      steps.add(checklistintruct(
          description: '', count: steps.length + 1, isvideo: false));

      // Add a null value to the selectimageurl list for the new step
      selectimageurl.add(null);
      originalimageurl.add(null);
      descriptionControllers.add(TextEditingController(text: ""));
    });
  }

  Future<void> saveGetStorageUrls() async {
    for (int index = 0; index < steps.length; index++) {
      //final steplist = steps[index].ImgUrl;

      final uploadurl = selectimageurl[index]?.toString();

      final og = originalimageurl[index];

      //print("step   $steplist");

      if (og != uploadurl) {
        steps[index].media = await FirebaseUtils.uploadImageToStorage(
            selectimageurl[index], steps[index].isvideo);
      }
    }
  }

  Future<void> _pickimggallery(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectimageurl[index] = File(image.path);
        steps[index].media = File(image.path).toString();
        steps[index].isvideo = false;
      });
    }
  }

  Future<void> _pickimgcamera(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        selectimageurl[index] = File(image.path);
        steps[index].media = File(image.path).toString();
        steps[index].isvideo = false;
      });
    }
  }

  Future<void> videoPickGallery(index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? media = await picker.pickVideo(source: ImageSource.gallery);
    if (media != null) {
      setState(() {
        selectimageurl[index] = File(media.path);
        steps[index].media = File(media.path).toString();
        steps[index].isvideo = true;
      });
    }
  }

  Future<void> videoPickCamera(index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? media = await picker.pickVideo(source: ImageSource.camera);
    if (media != null) {
      setState(() {
        selectimageurl[index] = File(media.path);
        steps[index].media = File(media.path).toString();
        steps[index].isvideo = true;
      });
    }
  }

  Widget getterimg(int index) {
    if (steps[index].isvideo == true) {
      return Text("Video preview not avaible",
          style: (TextStyle(fontWeight: FontWeight.bold)));
    } else if (selectimageurl[index] is File) {
      return Image.file(selectimageurl[index]!);
    } else if (selectimageurl[index] is String) {
      return CachedNetworkImage(
        imageUrl: steps[index].media!,
        placeholder: (context, url) => LinearProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset("placeholder_image.png"),
      );
    } else if (selectimageurl[index] == null && steps[index].media == null) {
      return Text('Please Upload image');
    } else {
      // Return a default widget if none of the above conditions are met.
      return Text('Invalid Image');
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

  void deletestep(index) async {
    setState(() {
      descriptionControllers[index].dispose(); // Dispose of the controller
      descriptionControllers
          .removeAt(index); // Remove the controller from the list
      steps.removeAt(index);
      originalimageurl.removeAt(index);
      selectimageurl.removeAt(index);
    });
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
        title: Text('Checklist Editor'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Save Recipe"),
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
                                updateRecipe();
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
                    title: Text(" Delete checklist?"),
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
                                print(keyid);
                                // Perform the action when "Yes" is clicked.
                                // You can call your function here.
                                await FirebaseUtils.deleteChecklist(
                                    keyid, steps, context);

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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Checklist Name',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter recipe name',
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    color: Color.fromRGBO(30, 39, 73, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'List ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  for (int index = 0; index < steps.length; index++)
                    _buildStepCard(index),
                  // Add Step button
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _addStep,
                        child: Text('Add Step'),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'To delete step, long press a step',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(int index) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(" Delete step?"),
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
                          setState(() {
                            deletestep(index);
                          });

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
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Check No.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    // Wrap the TextFormField with Expanded
                    child: TextFormField(
                      maxLines: null,
                      initialValue: steps[index].count.toString(),
                      onChanged: (value) {
                        try {
                          if (value.isNotEmpty) {
                            steps[index].count = int.parse(value);
                          } else {
                            steps[index].count =
                                0; // Handle empty input gracefully
                          }
                        } catch (e) {
                          // Handle the error here (e.g., show a message or set a default value)
                          print('Error parsing input: $e');
                          steps[index].count = 0; // Set a default value
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter check number',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: isScreenWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          // Wrap the Column with Expanded
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                maxLines: null,
                                controller: descriptionControllers[index],
                                onChanged: (value) {
                                  steps[index].description = value;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter step description',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Image/Video',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              getterimg(index),
                              Row(
                                children: [
                                  ElevatedButton(
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        _pickimggallery(index);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text("Image"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        videoPickGallery(index);
                                                        Navigator.of(context)
                                                            .pop();
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
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text("Choosing from gallery"),
                                            content: Text(
                                                "What type do you want to upload ?"),
                                            actions: <Widget>[
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        _pickimgcamera(index);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text("Image"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        videoPickCamera(index);
                                                        Navigator.of(context)
                                                            .pop();
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
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: null,
                          controller: descriptionControllers[index],
                          onChanged: (value) {
                            steps[index].description = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter check description',
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Image/Video',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        getterimg(index),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
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
                                                onPressed: () {
                                                  _pickimggallery(index);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Image"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  videoPickGallery(index);
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
                                                onPressed: () {
                                                  _pickimgcamera(index);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Image"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  videoPickCamera(index);
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

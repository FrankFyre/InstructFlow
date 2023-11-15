// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instructflow/classtypes/recipedata.dart';
import 'package:instructflow/classtypes/stepsrecipe.dart';
import 'package:instructflow/databaseUtils/saverecipe.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:io';

class RecipeCreator extends StatefulWidget {
  @override
  _RecipeCreatorState createState() => _RecipeCreatorState();
}

class _RecipeCreatorState extends State<RecipeCreator> {
  late TextEditingController nameController;
  late String menuid;

  late List<StepsRecipe> steps;
  List<dynamic> selectimageurl = [];
  List<dynamic> originalimageurl = [];
  List<TextEditingController> descriptionControllers = [];
  File? thumnuu;
  late bool thumbnail;
  late String upthumbnail;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    menuid = "1"; // Initialize menuid as an empty string
    steps = [StepsRecipe(stepcount: 1, description: '', isvid: false)];
    getImageUrls(steps);
    thumbnail = false;
    upthumbnail = '';
    for (int i = 0; i < steps.length; i++) {
      descriptionControllers
          .add(TextEditingController(text: steps[i].description));
    }
  }

  List<dynamic> getImageUrls(steps) {
    List<dynamic> imageUrls = [];

    for (int index = 0; index < steps.length; index++) {
      if (steps[index].ImgUrl != null) {
        selectimageurl.add(steps[index].ImgUrl);
        originalimageurl.add(steps[index].ImgUrl);
      } else {
        selectimageurl.add(null);
        originalimageurl.add(null);
      }
    }

    return imageUrls;
  }

  Future<void> saveGetStorageUrls() async {
    if (thumbnail == true) {
      upthumbnail = await FirebaseUtils.uploadthumbToStorage(thumnuu!);
      setState(() {
        upthumbnail;
      });
    }

    for (int index = 0; index < steps.length; index++) {
      //final steplist = steps[index].ImgUrl;

      final uploadurl = selectimageurl[index]?.toString();

      final og = originalimageurl[index];

      if (og != uploadurl) {
        steps[index].ImgUrl = await FirebaseUtils.uploadImageToStorage(
            selectimageurl[index], steps[index].isvid);
      }
    }
  }

  Future<void> createRecipe() async {
    final Recipe newRecipe = Recipe(
      uniqid: menuid,
      keyid: '', // Initialize keyid as an empty string
      name: nameController.text,
      steps: List.from(steps),
      thumbnail: upthumbnail, // You can set a default thumbnail here if needed
    );

    await FirebaseUtils.saveNewRecipeToFirebase(
      newRecipe,
      nameController,
      menuid,
      steps,
      context,
    );
  }

  void _addStep() {
    setState(() {
      steps.add(StepsRecipe(
          stepcount: steps.length + 1, description: '', isvid: false));

      descriptionControllers.add(TextEditingController(text: ""));
      selectimageurl.add(null);
      originalimageurl.add(null);
    });
  }

  Future<void> _pickimggallery(int index, int loop) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (loop == 1) {
      if (image != null) {
        setState(() {
          selectimageurl[index] = File(image.path);
          steps[index].ImgUrl = File(image.path).toString();
          steps[index].isvid = false;
        });
      }
    } else if (loop == 2) {
      if (image != null) {
        setState(() {
          thumbnail = true;
          thumnuu = File(image.path);
        });
      }
    }
  }

  Future<void> _pickimgcamera(int index, int loop) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (loop == 1) {
      if (image != null) {
        setState(() {
          selectimageurl[index] = File(image.path);
          steps[index].ImgUrl = File(image.path).toString();
          steps[index].isvid = false;
        });
      }
    } else if (loop == 2) {
      if (image != null) {
        setState(() {
          thumbnail = true;
          thumnuu = File(image.path);
        });
      }
    }
  }

  Future<void> videoPickGallery(index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? media = await picker.pickVideo(source: ImageSource.gallery);
    if (media != null) {
      setState(() {
        selectimageurl[index] = File(media.path);
        steps[index].ImgUrl = File(media.path).toString();
        steps[index].isvid = true;
      });
    }
  }

  Future<void> videoPickCamera(index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? media = await picker.pickVideo(source: ImageSource.camera);
    if (media != null) {
      setState(() {
        selectimageurl[index] = File(media.path);
        steps[index].ImgUrl = File(media.path).toString();
        steps[index].isvid = true;
      });
    }
  }

  Widget getterimg(int index) {
    if (steps[index].isvid == true) {
      return Text("Video preview not avaible",
          style: (TextStyle(fontWeight: FontWeight.bold)));
    } else if (selectimageurl[index] is File) {
      return Image.file(selectimageurl[index]!);
    } else if (selectimageurl[index] is String) {
      return CachedNetworkImage(
        imageUrl: steps[index].ImgUrl!,
        placeholder: (context, url) => LinearProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset("placeholder_image.png"),
      );
    } else if (selectimageurl[index] == null && steps[index].ImgUrl == null) {
      return Text('Please Upload image');
    } else {
      // Return a default widget if none of the above conditions are met.
      return Text('Invalid Image');
    }
  }

  Widget getterthumnail() {
    if (thumbnail == true) {
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
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
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
          title: Text('Recipe Creator'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Create Recipe"),
                      content: Text("Confirm ?"),
                      actions: <Widget>[
                        Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              child: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              child: Icon(Icons.done),
                              onPressed: () async {
                                progresindi();

                                await saveGetStorageUrls();
                                await createRecipe();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ))
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
                        child: Flex(
                          direction: isScreenWide
                              ? Axis.horizontal
                              : Axis
                                  .vertical, // Determine the direction based on screen width
                          children: [
                            Expanded(
                              flex: isScreenWide
                                  ? 8
                                  : 0, // Flex value based on screen width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recipe Name',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter recipe name',
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Menu Number',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    initialValue: menuid.toString(),
                                    onChanged: (value) {
                                      menuid = value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter menu',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                width: isScreenWide
                                    ? 40
                                    : 0), // Add spacing only on wider screens
                            Expanded(
                              flex: isScreenWide
                                  ? 2
                                  : 0, // Flex value based on screen width
                              child: Column(
                                children: [
                                  Text(
                                    'Thumbnail Image',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  getterthumnail(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _pickimggallery(1, 2);
                                        },
                                        child: Text("Gallery"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _pickimgcamera(1, 2);
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
        ));
  }

  // Implement the _buildStepCard and other methods for image picking and rendering here, similar to RecipeEditor
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
              child: Flex(
                crossAxisAlignment: CrossAxisAlignment.start,
                direction: isScreenWide ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                    flex: isScreenWide ? 1 : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Step No.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: null,
                          initialValue: steps[index].stepcount.toString(),
                          onChanged: (value) {
                            try {
                              if (value.isNotEmpty) {
                                steps[index].stepcount = int.parse(value);
                              } else {
                                steps[index].stepcount =
                                    0; // Handle empty input gracefully
                              }
                            } catch (e) {
                              // Handle the error here (e.g., show a message or set a default value)
                              print('Error parsing input: $e');
                              steps[index].stepcount = 0; // Set a default value
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter step number',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: isScreenWide ? 20 : 0,
                  ),
                  Expanded(
                    flex: isScreenWide ? 1 : 0,
                    child: Column(
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
                            hintText: 'Enter step description',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: isScreenWide ? 16 : 0,
                  ),
                  Expanded(
                    flex: isScreenWide ? 1 : 0,
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
                                                  _pickimggallery(index, 1);
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
                                                  _pickimgcamera(index, 1);
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

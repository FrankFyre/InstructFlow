// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instructflow/classtypes/recipedata.dart';
import 'package:instructflow/services/texttospeech.dart';
import 'package:instructflow/classtypes/stepsrecipe.dart';

import 'package:instructflow/services/translator.dart';
import 'package:instructflow/services/videoplayer.dart';
import 'package:instructflow/services/imageProvider.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class RecipeStepPage extends StatefulWidget {
  final Recipe recipe;

  RecipeStepPage({required this.recipe});

  @override
  _RecipeStepPageState createState() => _RecipeStepPageState();
}

class _RecipeStepPageState extends State<RecipeStepPage> {
  int currentStep = 0; // Tracks the current step in the recipe.

  String dropdown = 'gb_en';
  bool isitsamelang = false;
  bool countdown = false;
  int timer = 0;

  Widget finishbutton(int currentStep, stepList, context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;
    if (currentStep == stepList.length - 1) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop(); // Pop the current page
        },
        child: Card(
            color: Color.fromRGBO(244, 219, 216, 0.1),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              side: BorderSide(
                color: Color.fromRGBO(242, 175, 41, 1),
              ),
            ),
            child: Center(
                child: Text(
              'Finish and close',
              style: TextStyle(
                color: Colors.white,
                fontSize: isScreenWide ? 25 : 15,
              ),
            ))),
      );
    } else {
      // Display the current step count

      return Container(
        decoration: const BoxDecoration(
          border: Border(),
        ),
        child: Center(
            child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.transparent, width: 0, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10),
          ), // Shadow color

          child: Padding(
            padding: const EdgeInsets.all(11.0),
            child: Text(
              'Step ${currentStep + 1} / ${stepList.length}',
              style: TextStyle(
                fontSize: isScreenWide ? 25 : 15,
                color: Color.fromRGBO(242, 175, 41, 1),
              ),
            ),
          ),
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize or get the recipe data from the previous page
    Recipe recipe = widget.recipe;
    List<StepsRecipe> stepList = recipe.steps;
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 219, 216, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(30, 39, 73, 1),
        title: Text(recipe.name),
      ),
      body: Container(
        decoration: BoxDecoration(
          // Shadow color
          gradient: RadialGradient(
            radius: 2.5,
            center: Alignment(-0.9, -0.8),
            colors: const [
              Color.fromRGBO(55, 209, 255, 1),
              Color.fromRGBO(14, 31, 111, 1),
            ],
            stops: const [0, 1.02],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  direction: isScreenWide ? Axis.horizontal : Axis.vertical,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            child: stepList[currentStep].isvid
                                ? Playvideo(url: stepList[currentStep].ImgUrl!)
                                : ImageViewer(
                                    imageUrl: stepList[currentStep].ImgUrl),
                          )),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              // Swiping in right direction.
                              if (details.delta.dx > 8) {
                                // Step counter assurance
                                if (currentStep != 0) {
                                  setState(() {
                                    currentStep--;
                                    // Reinitialize video controller for new step
                                  });
                                }
                              }

                              // Swiping in left direction.
                              if (details.delta.dx < -8) {
                                // Step counter assurance
                                if (currentStep != stepList.length - 1) {
                                  setState(() {
                                    currentStep++;
                                    // Reinitialize video controller for new step
                                  });
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(30, 39, 73, 0.5),
                                border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                    style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.circular(10), // Shadow color
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Step ${currentStep + 1}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    isScreenWide ? 40 : 20,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    SizedBox(height: 16),

                                    Expanded(
                                      flex: 1,
                                      child: isitsamelang
                                          ? FutureBuilder<dynamic>(
                                              future: translator(
                                                  dropdown,
                                                  stepList[currentStep]
                                                      .description),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  // While the translation is in progress, you can show a loading indicator or placeholder text.
                                                  return Text(
                                                    stepList[currentStep]
                                                        .description,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: isScreenWide
                                                          ? 30
                                                          : 20,
                                                    ),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  // If there's an error in translation, you can handle it here.
                                                  return Text(
                                                      "Translation Error: ${snapshot.error}");
                                                } else {
                                                  // Translation is complete, display the translated text.
                                                  return Text(
                                                    snapshot.data ??
                                                        stepList[currentStep]
                                                            .description,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: isScreenWide
                                                          ? 30
                                                          : 20,
                                                    ),
                                                  );
                                                }
                                              },
                                            )
                                          : Text(
                                              stepList[currentStep].description,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    isScreenWide ? 30 : 20,
                                              ),
                                            ),
                                    ),

                                    SizedBox(
                                        height:
                                            16), // Spacer between text and buttons
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Spacer between image/video and text/buttons
              // Right side: Text and Navigation Buttons
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Card(
                        color: Color.fromRGBO(242, 175, 41, 1),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(
                            color: Color.fromRGBO(242, 175, 41, 1),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (currentStep > 0) {
                              setState(() {
                                currentStep--;
                                // Reinitialize video controller for new step
                              });
                            }
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Card(
                        color: Color.fromRGBO(242, 175, 41, 1),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          side: BorderSide(
                            color: Color.fromRGBO(242, 175, 41, 1),
                          ),
                        ),
                        child: PopupMenuButton(
                          icon: const Icon(Icons.timer),
                          onSelected: (String selected) {
                            setState(() {
                              timer = int.parse(selected);
                              countdown = true;
                            });
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: '5', // Unique value for English
                              child: Text('5 sec'),
                            ),
                            PopupMenuItem(
                              value: '60', // Unique value for English
                              child: Text('1 min'),
                            ),
                            PopupMenuItem(
                              value: '120', // Unique value for Chinese
                              child: Text('2 min'),
                            ),
                            PopupMenuItem(
                              value: '180', // Unique value for Bahasa Melayu
                              child: Text('3 min'),
                            ),
                            PopupMenuItem(
                              value: '240', // Unique value for Tamil
                              child: Text('4 min'),
                            ),
                            PopupMenuItem(
                              value: '300', // Unique value for Hindi
                              child: Text('5 min'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Card(
                        color: Color.fromRGBO(242, 175, 41, 1),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          side: BorderSide(
                            color: Color.fromRGBO(242, 175, 41, 1),
                          ),
                        ),
                        child: PopupMenuButton(
                          icon: const Icon(Icons.translate),
                          onSelected: (String selected) {
                            setState(() {
                              if (dropdown == selected) {
                                isitsamelang = false;
                              } else if (dropdown != selected) {
                                dropdown = selected;
                                isitsamelang = true;
                              }
                            });
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'zh-CN', // Unique value for English
                              child: Text('中文'),
                            ),
                            PopupMenuItem(
                              value: 'ms', // Unique value for Chinese
                              child: Text('Bahasa Melayu'),
                            ),
                            PopupMenuItem(
                              value: 'ta', // Unique value for Bahasa Melayu
                              child: Text('தமிழ்'),
                            ),
                            PopupMenuItem(
                              value: 'hi', // Unique value for Tamil
                              child: Text('मानक हिन्दी'),
                            ),
                            PopupMenuItem(
                              value: 'gb_en', // Unique value for Hindi
                              child: Text('English'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Card(
                        color: Color.fromRGBO(242, 175, 41, 1),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          side: BorderSide(
                            color: Color.fromRGBO(242, 175, 41, 1),
                          ),
                        ),
                        child: IconButton(
                            onPressed: () async {
                              String currentText = await translator(
                                  dropdown, stepList[currentStep].description);
                              TtsService ttsService = TtsService(
                                  ttsText: currentText, lang: dropdown);
                              ttsService.speak();
                            },
                            icon: Icon(Icons.record_voice_over)),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Card(
                        color: Color.fromRGBO(242, 175, 41, 1),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(
                            color: Color.fromRGBO(242, 175, 41, 1),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (currentStep < stepList.length - 1) {
                              setState(() {
                                currentStep++;
                              });
                            }
                          },
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                  flex: 1,
                  child: countdown
                      ? Countdown(
                          seconds: timer,
                          build: (BuildContext context, double time) =>
                              Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(30, 39, 73, 0.5),
                              border: Border.all(
                                  color: Colors.transparent,
                                  width: 0,
                                  style: BorderStyle.solid),
                              borderRadius:
                                  BorderRadius.circular(10), // Shadow color
                            ),
                            child: Center(
                              child: Text(
                                "Time left:  ${time.toString()}",
                                style: TextStyle(
                                  fontSize: isScreenWide ? 25 : 15,
                                  color: Color.fromRGBO(242, 175, 41, 1),
                                ),
                              ),
                            ),
                          ),
                          interval: Duration(milliseconds: 100),
                          onFinished: () {
                            setState(() {
                              countdown = false;
                            });
                            FlutterRingtonePlayer.playNotification();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Timer is done"),
                                  actions: <Widget>[
                                    Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          child: Icon(Icons.done),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            // Close the dialog.
                                          },
                                        ),
                                      ],
                                    ))
                                  ],
                                );
                              },
                            );
                          },
                        )
                      : finishbutton(currentStep, stepList, context))
            ],
          ),
        ),
      ),
    );
  }
}

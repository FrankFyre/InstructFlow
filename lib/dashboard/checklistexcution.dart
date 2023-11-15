import 'package:flutter/material.dart';
import 'package:instructflow/classtypes/checklistclass.dart';

import 'package:instructflow/classtypes/checklistintructions.dart';
import 'package:instructflow/services/texttospeech.dart';
import 'package:instructflow/databaseUtils/logcheckdb.dart';
import 'package:intl/intl.dart';
import 'package:instructflow/services/translator.dart';

import 'package:instructflow/services/videoplayer.dart';
import 'package:instructflow/services/imageProvider.dart';

class checklistexcution extends StatefulWidget {
  final checklistclass check;
  final String employee;

  checklistexcution({
    required this.check,
    required this.employee,
  });

  @override
  State<checklistexcution> createState() => _checklistexcutionState();
}

class _checklistexcutionState extends State<checklistexcution> {
  int currentStep = 0;
  String dropdown = 'gb_en';

  bool isitsamelang = false;

  @override
  Widget build(BuildContext context) {
    checklistclass check = widget.check;

    List<checklistintruct> checkList = check.description;
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(238, 204, 201, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(48, 52, 63, 1),
        title: Text(check.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              radius: 2.5,
              center: Alignment(-0.9, -0.8),
              colors: [
                Color.fromRGBO(55, 209, 255, 1),
                Color.fromRGBO(14, 31, 111, 1),
              ],
              stops: [0, 1.02],
            ),
            border: Border.all(
                color: Colors.transparent, width: 0, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10), // Shadow color
          ),
          child: Flex(
            direction: isScreenWide ? Axis.horizontal : Axis.vertical,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: checkList[currentStep].isvideo!
                          ? Playvideo(url: checkList[currentStep].media!)
                          : ImageViewer(
                              imageUrl: checkList[currentStep].media!)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(30, 39, 73, 0.5),
                                border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                    style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.circular(10), // Shadow color
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  "Step ${currentStep + 1} /${checkList.length}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isScreenWide ? 20 : 15,
                                  ),
                                )),
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(30, 39, 73, 0.5),
                              border: Border.all(
                                  color: Colors.transparent,
                                  width: 0,
                                  style: BorderStyle.solid),
                              borderRadius:
                                  BorderRadius.circular(10), // Shadow color
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: isScreenWide
                                    ? Alignment.centerLeft
                                    : Alignment.topLeft,
                                child: isitsamelang
                                    ? FutureBuilder<dynamic>(
                                        future: translator(
                                          dropdown,
                                          checkList[currentStep].description,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            // While the translation is in progress, you can show a loading indicator or placeholder text.
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            // If there's an error in translation, you can handle it here.
                                            return Text(
                                                "Translation Error: ${snapshot.error}");
                                          } else {
                                            // Translation is complete, display the translated text.
                                            return Text(
                                              snapshot.data ??
                                                  checkList[currentStep]
                                                      .description,
                                              style: TextStyle(
                                                  fontSize:
                                                      isScreenWide ? 40 : 20,
                                                  color: Colors.white),
                                            );
                                          }
                                        },
                                      )
                                    : Text(
                                        checkList[currentStep].description,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isScreenWide ? 30 : 20,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    child: PopupMenuButton(
                                      icon: const Icon(Icons.translate),
                                      onSelected: (String selected) {
                                        if (dropdown == selected) {
                                          isitsamelang = false;
                                        } else if (dropdown != selected) {
                                          dropdown = selected;
                                          isitsamelang = true;
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value:
                                              'zh-CN', // Unique value for English
                                          child: Text('中文'),
                                        ),
                                        const PopupMenuItem(
                                          value:
                                              'ms', // Unique value for Chinese
                                          child: Text('Bahasa Melayu'),
                                        ),
                                        const PopupMenuItem(
                                          value:
                                              'ta', // Unique value for Bahasa Melayu
                                          child: Text('தமிழ்'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'hi', // Unique value for Tamil
                                          child: Text('मानक हिन्दी'),
                                        ),
                                        const PopupMenuItem(
                                          value:
                                              'gb_en', // Unique value for Hindi
                                          child: Text('English'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    child: IconButton(
                                      onPressed: () async {
                                        String currrenttext = await translator(
                                            dropdown,
                                            checkList[currentStep].description);

                                        TtsService ttsService = TtsService(
                                            ttsText: currrenttext,
                                            lang: dropdown);
                                        ttsService.speak();
                                      },
                                      icon: const Icon(Icons.record_voice_over),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    child: IconButton(
                                      onPressed: () async {
                                        if (currentStep !=
                                            checkList.length - 1) {
                                          setState(() {
                                            currentStep++;
                                          });
                                        } else {
                                          await FirebaseService().logCheckList(
                                              widget.employee, // Employee name
                                              DateFormat(" dd,MMMM, yyyy")
                                                  .format(
                                                      DateTime.now()), // Date
                                              DateFormat("HH:mm:ss").format(
                                                  DateTime.now()), // Time
                                              widget
                                                  .check.name // Checklist name
                                              );
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "You have completed ${check.name}"),
                                                actions: <Widget>[
                                                  Center(
                                                    child: ElevatedButton(
                                                      child: const Icon(
                                                          Icons.done),
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();

                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog.
                                                      },
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.done),
                                    ),
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}

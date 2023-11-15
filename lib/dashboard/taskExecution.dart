import 'package:flutter/material.dart';

import 'package:instructflow/services/texttospeech.dart';
import 'package:instructflow/databaseUtils/logcheckdb.dart';

import 'package:instructflow/classtypes/taskclass.dart';
import 'package:instructflow/services/translator.dart';
import 'package:instructflow/services/videoplayer.dart';

import 'package:instructflow/services/imageProvider.dart';

class taskexpanded extends StatefulWidget {
  final TaskClass task;
  final String employee;

  taskexpanded({
    required this.task,
    required this.employee,
  });

  @override
  State<taskexpanded> createState() => _taskexpandedState();
}

class _taskexpandedState extends State<taskexpanded> {
  String dropdown = 'gb_en';

  @override
  Widget build(BuildContext context) {
    TaskClass task = widget.task;
    bool isScreenWide = MediaQuery.of(context).size.width >= 450;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(238, 204, 201, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(48, 52, 63, 1),
        title: Text(task.name),
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
            // color: Color.fromRGBO(39, 52, 105, 1),
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
                      child: task.isvideo
                          ? Playvideo(url: task.mediaUrl)
                          : ImageViewer(imageUrl: task.mediaUrl)),
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
                        flex: 3,
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
                                padding: const EdgeInsets.all(15.0),
                                child: Align(
                                  alignment: isScreenWide
                                      ? Alignment.centerLeft
                                      : Alignment.topLeft,
                                  child: FutureBuilder<dynamic>(
                                    future: translator(
                                      dropdown,
                                      task.description,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        // While the translation is in progress, you can show a loading indicator or placeholder text.
                                        return const LinearProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // If there's an error in translation, you can handle it here.
                                        return Text(
                                            "Translation Error: ${snapshot.error}");
                                      } else {
                                        // Translation is complete, display the translated text.
                                        return Text(
                                          snapshot.data ?? task.description,
                                          style: TextStyle(
                                              fontSize: isScreenWide ? 40 : 20,
                                              color: Colors.white),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              )),
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
                                        setState(() {
                                          dropdown = selected;
                                        });
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
                                            dropdown, task.description);

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
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Update task status"),
                                              content: const Text(
                                                  "Have you completed the task ?"),
                                              actions: <Widget>[
                                                Center(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      child: const Icon(
                                                          Icons.close),
                                                      onPressed: () {
                                                        // Close the dialog without performing any action.
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child: const Icon(
                                                          Icons.done),
                                                      onPressed: () {
                                                        // Perform the action when "Yes" is clicked.
                                                        // You can call your function here.
                                                        FirebaseService()
                                                            .deleteAndMoveTaskToCompleted(
                                                                task.keyid);
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog.
                                                      },
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.check_circle),
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

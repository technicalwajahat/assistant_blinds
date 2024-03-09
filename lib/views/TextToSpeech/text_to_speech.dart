import 'dart:io';

import 'package:assistant_blinds/widgets/appBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/text_to_speech_controller.dart';

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({super.key});

  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final textToSpeechController = Get.put(TextSpeechController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: "Text to Speech"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child:
            GetBuilder<TextSpeechController>(builder: (textToSpeechController) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  textToSpeechController.pickFiles();
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.upload_file_rounded, size: 34),
                          SizedBox(height: Get.height * 0.01),
                          const AutoSizeText(
                            "Upload Document",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              textToSpeechController.pickedFilePath != null
                  ? Column(
                      children: [
                        ListTile(
                          title: AutoSizeText(
                            textToSpeechController.pickedFilePath!.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: AutoSizeText(
                            "File Size: ${textToSpeechController.getFileSizeText(textToSpeechController.pickedFilePath!.size)}",
                          ),
                          leading: const Icon(
                            Icons.file_copy_rounded,
                            size: 28,
                          ),
                          dense: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.open_in_new_rounded),
                            onPressed: () => textToSpeechController.openFile(
                                textToSpeechController.pickedFilePath!.path),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.025),
                        FilledButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            textToSpeechController.uploadDocument(
                                File(textToSpeechController
                                    .pickedFilePath!.path!),
                                context);
                          },
                          child: const AutoSizeText(
                            "Convert Text to Speech",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: AutoSizeText(
                        "Please Select Document",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
            ],
          );
        }),
      ),
    );
  }
}

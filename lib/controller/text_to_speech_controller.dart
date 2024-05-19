import 'dart:io';

import 'package:assistant_blinds/repository/text_to_speech_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class TextSpeechController extends GetxController {
  PlatformFile? pickedFilePath;

  final _textToSpeechRepo = Get.put(TextToSpeechRepository());

  // Send File to API
  void sendDocToAPI(File file, BuildContext context) async {
    await _textToSpeechRepo.sendDocumentToAPI(file, context).then((value) {
      Get.toNamed('/viewSpeech');
    });
  }

  // PickFiles from File Manager
  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: false,
    );
    if (result != null) {
      final file = result.files.single;
      pickedFilePath = file;
      update();
    }
  }

  // Get File Size
  String getFileSizeText(int size) {
    if (size <= 1024) {
      return '$size bytes';
    } else if (size <= 1048576) {
      return '${(size / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(size / 1048576).toStringAsFixed(2)} MB';
    }
  }

  // Open File
  Future<void> openFile(String? filePath) async {
    await OpenFile.open(filePath);
  }
}

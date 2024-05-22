import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../utils/utils.dart';

class TextToSpeechRepository extends GetxController {
  static TextToSpeechRepository get instance => Get.find();

  // Send Document to API
  Future<http.StreamedResponse?> sendDocumentToAPI(
      File file, BuildContext context) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse("http://10.0.2.2:8000/convert-pptx-to-audio"));

      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: file.path.split('/').last,
          contentType: MediaType("application",
              "vnd.openxmlformats-officedocument.presentationml.presentation"));
      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        Utils.snackBar("Document Sent Successfully", context);
        // Read response stream as string
        String responseString = await response.stream.bytesToString();
        print(responseString);
      } else {
        Utils.snackBar(
            "Failed to send file. Error: ${response.statusCode}", context);
        return null;
      }
    } catch (e) {
      Utils.snackBar("Error sending file: $e", context);
      return null;
    }
    return null;
  }
}

String getFileContentType(File file) {
  String path = file.path.toLowerCase();
  if (path.endsWith('.pdf')) {
    return 'application/pdf';
  } else if (path.endsWith('.doc') || path.endsWith('.docx')) {
    return 'application/msword';
  } else {
    return 'application/octet-stream';
  }
}

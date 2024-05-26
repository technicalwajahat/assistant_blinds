import 'dart:io';

import 'package:assistant_blinds/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../utils/utils.dart';

class TextToSpeechRepository extends GetxController {
  static TextToSpeechRepository get instance => Get.find();

  // Send File Document to API
  Future<String?> sendDocumentToAPI(File file, BuildContext context) async {
    try {
      var type = getFileContentType(file);

      var request = http.MultipartRequest(
          'POST', Uri.parse("http://10.0.2.2:8000/${type[1]}"));

      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: file.path.split('/').last,
        contentType: MediaType("application", type[0]),
      );
      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        Utils.snackBar("Document Sent Successfully", context);
        var responseString = await response.stream.bytesToString();
        return responseString;
      } else {
        Utils.snackBar(
            "Failed to send file. Error: ${response.statusCode}", context);
        return null;
      }
    } catch (e) {
      Utils.snackBar("Error sending file: $e", context);
      return null;
    }
  }
}

List<String> getFileContentType(File file) {
  String path = file.path.toLowerCase();
  if (path.endsWith('.pdf')) {
    return TYPE_PDF;
  } else if (path.endsWith('.doc') || path.endsWith('.docx')) {
    return TYPE_DOCX;
  } else if (path.endsWith('.pptx')) {
    return TYPE_PPTX;
  } else {
    return ["octet-stream", ""];
  }
}

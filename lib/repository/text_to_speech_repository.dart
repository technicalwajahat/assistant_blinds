import 'dart:io';

import 'package:assistant_blinds/model/AudiosModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../utils/utils.dart';

class TextToSpeechRepository extends GetxController {
  static TextToSpeechRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  // Fetch All Audios
  Future<List<AudiosModel>> fetchAllAudios() async {
    final snapshot = await _db.collection("audios").get();
    return snapshot.docs.map((e) => AudiosModel.fromSnapshot(e)).toList();
  }

  // Send Document to API
  Future<http.StreamedResponse?> sendDocumentToAPI(
      File file, BuildContext context) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse("http://10.0.2.2:8000/convert-to-audio"));
      String contentType = getFileContentType(file);

      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: file.path.split('/').last);
      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        Utils.snackBar("Document Sent Successfully", context);
        final responseData = await response.stream.toBytes();
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

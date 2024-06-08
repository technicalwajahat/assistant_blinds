import 'package:assistant_blinds/widgets/appBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ViewSpeech extends StatefulWidget {
  const ViewSpeech({super.key});

  @override
  State<ViewSpeech> createState() => _ViewSpeechState();
}

class _ViewSpeechState extends State<ViewSpeech> {
  final FlutterTts flutterTts = FlutterTts();
  var arguments = Get.arguments;
  String? appDocumentsDirectory;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) {
      appDocumentsDirectory = getApplicationDocumentsDirectory().toString();
      convertTextToSpeech(arguments);
    } else {
      _handlePermissionDenied();
    }
  }

  void _handlePermissionDenied() {
    Get.dialog(
      AlertDialog(
        title: const Text('Storage Permission Required'),
        content: const Text(
            'This app needs storage permission to save spoken text.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Permission.storage.request(),
            child: const Text('Request Permission'),
          ),
        ],
      ),
    );
  }

  Future<void> convertTextToSpeech(String text) async {
    await flutterTts.speak(text);
    if (appDocumentsDirectory != null) {
      try {
        await flutterTts.synthesizeToFile(text, 'blind_tts.mp3');
      } catch (error) {
        print('Error saving file: $error');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: "View Speech"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AutoSizeText(arguments),
            ],
          ),
        ),
      ),
    );
  }
}

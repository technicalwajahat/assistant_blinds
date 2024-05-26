import 'package:assistant_blinds/widgets/appBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ViewSpeech extends StatefulWidget {
  const ViewSpeech({super.key});

  @override
  State<ViewSpeech> createState() => _ViewSpeechState();
}

class _ViewSpeechState extends State<ViewSpeech> {
  var arguments = Get.arguments;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    convertTextToSpeech(arguments);
  }

  void convertTextToSpeech(String text,
      {String fileName = 'tts_speech.mp3'}) async {
    flutterTts = FlutterTts();

    final appDirectory = await getExternalStorageDirectory();
    String filePath = '${appDirectory!.path}/$fileName';

    await flutterTts.speak(text);
    await flutterTts.synthesizeToFile(text, filePath);
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

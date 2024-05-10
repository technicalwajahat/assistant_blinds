import 'package:assistant_blinds/widgets/appBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../preferences/theme_preferences.dart';
import '../../repository/gemini_ai_service.dart';
import '../../widgets/feature_box.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String prompt = '';

  final GeminiAPIService geminiAIService = GeminiAPIService();
  String? generatedContent;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    systemSpeak("Hi, How are you?");
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      prompt = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: const AppBarWidget(text: "Gemini Bot"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                top: 30,
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: provider.darkTheme ? Colors.white : Colors.black),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: AutoSizeText(
                  generatedContent == null
                      ? 'Hi, what task can I do for you?'
                      : generatedContent!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: generatedContent == null ? 25 : 18,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null,
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 10, left: 22),
                child: const AutoSizeText(
                  'Here are a few features',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null,
              child: const Column(
                children: [
                  FeatureBox(
                    color: Colors.lightGreen,
                    headerText: 'Gemini',
                    descriptionText:
                        'A smarter way to stay organized and informed with Gemini',
                  ),
                  FeatureBox(
                    color: Colors.lightGreen,
                    headerText: 'Smart Voice Assistant',
                    descriptionText:
                        'Get the best of both worlds with a voice assistant powered by Gemini',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            final speech = await geminiAIService.promptApi(prompt);
            generatedContent = speech;
            setState(() {});

            await systemSpeak(speech.toString());
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: Icon(
          speechToText.isListening ? Icons.stop : Icons.mic,
        ),
      ),
    );
  }
}

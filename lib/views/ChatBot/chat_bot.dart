import 'package:assistant_blinds/widgets/appBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  var prompt = 'ChatBot';

  var isListening = false;

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
    systemSpeak("Hi, Welcome to ChatBot");
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: (result) {
      setState(() {
        prompt = result.recognizedWords;
      });
    });
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
    return Scaffold(
      appBar: const AppBarWidget(text: "Voice ChatBot"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.02),
                  Visibility(
                    visible: generatedContent == null,
                    child: Image.asset(
                      "assets/chatbot.png",
                      width: 140,
                      height: 140,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: AutoSizeText(
                        generatedContent == null
                            ? 'Hi, Welcome to ChatBot'
                            : generatedContent!
                                .replaceAll("*", "")
                                .replaceAll(".", ""),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: generatedContent == null ? 24 : 16,
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
                          headerText: 'ChatBot',
                          descriptionText:
                              'A smarter way to stay organized and informed with Voice Chat',
                        ),
                        FeatureBox(
                          color: Colors.lightGreen,
                          headerText: 'Smart Voice Assistant',
                          descriptionText:
                              'Get the best of both worlds with a voice assistant.',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        glowColor: Colors.greenAccent,
        repeat: true,
        animate: isListening,
        duration: const Duration(milliseconds: 3000),
        child: FloatingActionButton(
          onPressed: () async {
            if (!isListening) {
              setState(() {
                isListening = true;
              });
              startListening();
            } else {
              setState(() {
                isListening = false;
              });
              stopListening();
              await geminiAIService.promptApi(prompt).then((response) {
                setState(() {
                  generatedContent = response;
                });
                systemSpeak(response.toString());
              });
            }
          },
          tooltip: "Voice Assistance",
          child: Icon(
            isListening ? Icons.stop_circle_rounded : Icons.mic,
          ),
        ),
      ),
    );
  }
}

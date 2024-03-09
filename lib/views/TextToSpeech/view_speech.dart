import 'package:assistant_blinds/widgets/appBar.dart';
import 'package:flutter/material.dart';

class ViewSpeech extends StatefulWidget {
  const ViewSpeech({super.key});

  @override
  State<ViewSpeech> createState() => _ViewSpeechState();
}

class _ViewSpeechState extends State<ViewSpeech> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(text: "View Speech"),
    );
  }
}

import 'package:assistant_blinds/widgets/appBar.dart';
import 'package:flutter/material.dart';

class SavedAudio extends StatefulWidget {
  const SavedAudio({super.key});

  @override
  State<SavedAudio> createState() => _SavedAudioState();
}

class _SavedAudioState extends State<SavedAudio> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(text: "Saved Audios"),
    );
  }
}

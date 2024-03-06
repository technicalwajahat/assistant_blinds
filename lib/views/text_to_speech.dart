import 'package:assistant_blinds/widgets/appBar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({super.key});

  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: "Text to Speech"),
      floatingActionButton: FloatingActionButton(
        tooltip: "Upload Document",
        onPressed: () {
          _pickFiles();
        },
        child: const Icon(Icons.upload_file_rounded),
      ),
    );
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ppt', 'pdf', 'doc'],
    );
    if (result != null) {
      print(result.files.first.path);
    } else {
      print("No file picked.");
    }
  }
}

import 'package:assistant_blinds/widgets/appBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({super.key});

  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  PlatformFile? pickedFilePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: "Text to Speech"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                _pickFiles();
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.upload_file_rounded, size: 34),
                        SizedBox(height: Get.height * 0.01),
                        const AutoSizeText(
                          "Upload Document",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.04),
            pickedFilePath != null
                ? Column(
                    children: [
                      // AutoSizeText(
                      //   textAlign: TextAlign.center,
                      //   '$pickedFilePath',
                      //   style: const TextStyle(
                      //       fontSize: 14, fontWeight: FontWeight.w600),
                      // ),
                      ListTile(
                        title: AutoSizeText(
                          pickedFilePath!.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        // File name
                        subtitle: AutoSizeText(
                          path.basename(
                            pickedFilePath!.path.toString(),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.open_in_new),
                          onPressed: () =>
                              _openFile(pickedFilePath!.path.toString()),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      FilledButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {},
                        child: const AutoSizeText(
                          "Convert Text to Speech",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: AutoSizeText(
                      "Please Select Document",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ppt', 'pdf', 'doc', 'docx'],
      allowMultiple: false,
    );
    if (result != null) {
      final file = result.files.single;
      setState(() {
        pickedFilePath = file;
      });
    } else {
      print("No file picked.");
    }
  }

  String _getFileSizeText(int size) {
    if (size <= 1024) {
      return '$size bytes';
    } else if (size <= 1048576) {
      return '${(size / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(size / 1048576).toStringAsFixed(2)} MB';
    }
  }

  Future<void> _openFile(String filePath) async {
    final url = Uri.file(filePath);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
    }
  }
}

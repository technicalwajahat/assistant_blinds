import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class TextSpeechController extends GetxController {
  PlatformFile? pickedFilePath;

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ppt', 'pdf', 'doc', 'docx'],
      allowMultiple: false,
    );
    if (result != null) {
      final file = result.files.single;
      pickedFilePath = file;
      update();
    }
  }

  String getFileSizeText(int size) {
    if (size <= 1024) {
      return '$size bytes';
    } else if (size <= 1048576) {
      return '${(size / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(size / 1048576).toStringAsFixed(2)} MB';
    }
  }

  Future<void> openFile(String? filePath) async {
    await OpenFile.open(filePath);
  }
}
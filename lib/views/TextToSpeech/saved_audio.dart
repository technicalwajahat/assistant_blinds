import 'dart:io';

import 'package:assistant_blinds/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SavedAudio extends StatefulWidget {
  const SavedAudio({super.key});

  @override
  State<SavedAudio> createState() => _SavedAudioState();
}

class _SavedAudioState extends State<SavedAudio> {
  late Future<List<FileSystemEntity>> _audioFiles;

  @override
  void initState() {
    super.initState();
    getAudioFiles();
    _audioFiles = getAudioFiles();
  }

  Future<List<FileSystemEntity>> getAudioFiles() async {
    Directory? musicDirectory = await getApplicationDocumentsDirectory();
    String musicPath = musicDirectory.path;
    final files = Directory(musicPath).listSync(recursive: true);
    return files.where((file) => file.path.endsWith('.mp3')).toList();
  }

  void _playAudio(String filePath) async {
    // final player = AudioPlayer();
    // await player.setAudioSource(AudioSource.uri(Uri.parse(filePath)));
    // player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: "Saved Audios"),
      body: FutureBuilder<List<FileSystemEntity>>(
        future: _audioFiles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final files = snapshot.data;
            return ListView.builder(
              itemCount: files!.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return ListTile(
                  title: Text(file.path.split('/').last),
                  onTap: () => _playAudio(file.path),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching audio files'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

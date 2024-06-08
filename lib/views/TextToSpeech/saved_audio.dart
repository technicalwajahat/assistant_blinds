import 'dart:io';

import 'package:assistant_blinds/widgets/appBar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SavedAudio extends StatefulWidget {
  const SavedAudio({super.key});

  @override
  State<SavedAudio> createState() => _SavedAudioState();
}

class _SavedAudioState extends State<SavedAudio> {
  late Future<List<FileSystemEntity>> _audioFiles;
  late AudioPlayer _player;
  String? _currentlyPlayingFilePath;

  @override
  void initState() {
    super.initState();
    _audioFiles = getAudioFiles();
    _player = AudioPlayer();
  }

  Future<List<FileSystemEntity>> getAudioFiles() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    final files = Directory(selectedDirectory!).listSync(recursive: true);
    return files.where((file) => file.path.endsWith('.mp3')).toList();
  }

  void _playAudio(String filePath) async {
    // Stop the currently playing audio if there is any
    if (_currentlyPlayingFilePath != null) {
      await _player.stop();
    }

    // Start playing the new audio file
    await _player.setAudioSource(AudioSource.uri(Uri.parse(filePath)));
    await _player.play();
    _currentlyPlayingFilePath = filePath;
  }

  @override
  void dispose() {
    _player.dispose(); // Dispose the player to release resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: "Saved Audios"),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<List<FileSystemEntity>>(
          future: _audioFiles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching audio files'));
            } else {
              final files = snapshot.data;
              if (files != null && files.isNotEmpty) {
                return ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.play_arrow_rounded),
                        trailing: const Text(
                          "Tap to play",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        title: Text(
                          file.path.split('/').last.replaceAll(".mp3", ""),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                        onTap: () => _playAudio(file.path),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No Audio Files Found!'));
              }
            }
          },
        ),
      ),
    );
  }
}

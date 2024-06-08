import 'dart:io';

import 'package:assistant_blinds/widgets/appBar.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class SavedAudio extends StatefulWidget {
  const SavedAudio({super.key});

  @override
  State<SavedAudio> createState() => _SavedAudioState();
}

class _SavedAudioState extends State<SavedAudio> {
  late AudioPlayer _audioPlayer;
  late File _selectedAudioFile;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();
    _audioPlayer.positionStream;
    _audioPlayer.bufferedPositionStream;
    _audioPlayer.durationStream;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await listMp3Files().then((files) {
      if (files.isNotEmpty) {
        setState(() {
          _selectedAudioFile = files.first;
          _audioPlayer.setFilePath(_selectedAudioFile.path);
        });
      }
    });
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  Future<List<File>> listMp3Files() async {
    try {
      const result = "/sdcard/Music";
      final directory = Directory(result);
      final mp3Files = await directory
          .list()
          .where((entity) => entity.path.endsWith('.mp3'))
          .map((entity) => File(entity.path))
          .toList();

      print(mp3Files);
      return mp3Files;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: "Saved Audio"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 4),
                      blurRadius: 4,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    "assets/audi_icon.jpg",
                    height: 350,
                    width: 350,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return ProgressBar(
                    barHeight: 8,
                    baseBarColor: Colors.grey,
                    bufferedBarColor: Colors.grey,
                    progressBarColor: Colors.green,
                    thumbColor: Colors.green,
                    timeLabelTextStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    progress: positionData?.position ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    onSeek: _audioPlayer.seek,
                  );
                },
              ),
              Controls(audioPlayer: _audioPlayer),
            ],
          ),
        ),
      ),
    );
  }
}

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: audioPlayer.seekToPrevious,
          icon: const Icon(Icons.skip_previous_rounded),
          iconSize: 60,
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;

            if (!(playing ?? false)) {
              return IconButton(
                  onPressed: audioPlayer.play,
                  iconSize: 80,
                  icon: const Icon(Icons.play_arrow_rounded));
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                icon: const Icon(Icons.pause_rounded),
                iconSize: 80,
              );
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 80,
            );
          },
        ),
        IconButton(
          onPressed: audioPlayer.seekToNext,
          icon: const Icon(Icons.skip_next_rounded),
          iconSize: 60,
        ),
      ],
    );
  }
}

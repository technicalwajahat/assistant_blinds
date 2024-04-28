import 'package:cloud_firestore/cloud_firestore.dart';

class AudiosModel {
  String? id;
  final String? audioPath;

  AudiosModel({
    this.id,
    this.audioPath,
  });

  factory AudiosModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return AudiosModel(
      id: document.id,
      audioPath: data!['audioPath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['audioPath'] = audioPath;
    return data;
  }
}

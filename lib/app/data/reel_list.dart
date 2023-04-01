import 'package:firebase_database/firebase_database.dart';

class Video {
  String VideoId;
  int id;

  Video({required this.VideoId, required this.id});
}

List<Video> videoPlayer = [
  Video(VideoId: 'asset/reel.mp4', id: 1),
  Video(VideoId: 'asset/reel1.mp4', id: 2),
  Video(VideoId: 'asset/reel1.mp4', id: 3),
  Video(VideoId: 'asset/reel.mp4', id: 4),
];

class firebaseDatabae {
  final String? id;
  final String VideoUrl;
  final int? like;

  firebaseDatabae(
      {required this.id,
      required this.VideoUrl,
      required this.like,
     });



}

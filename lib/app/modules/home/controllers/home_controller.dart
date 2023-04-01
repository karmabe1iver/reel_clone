import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reel_clone/app/data/firbase_database.dart';
import 'package:reel_clone/app/data/reel_list.dart';
import 'package:video_player/video_player.dart';

class HomeController extends GetxController {
  Rx<int> itemcount = videoData.length.obs;
  final user = FirebaseAuth.instance.currentUser;
  PageController pageController = PageController(initialPage: 0);
  Rx<bool> Isplay = false.obs;
  Rx<bool> liked = false.obs;
  Rx<int> Index = 0.obs;
  Rx<int?> Like = 0.obs;
  RxList<firebaseDatabae> Clips = videoData.obs;

  Rx<VideoPlayerController> videoPlayerController =
      VideoPlayerController.asset(videoPlayer.first.VideoId).obs;

  late Future<void> Intialize;

  void LikeAndDislike() {
    if (liked.value == false) {
      firebaseDatabase.LikeData(Index.value, videoData[Index.value].id!)
          .then((value) => {Like.value = videoData[Index.value].like! + 1,
      liked.value=true});
    } else {
      firebaseDatabase.UnlikeData(Index.value, videoData[Index.value].id!)
          .then((value) => {Like.value = videoData[Index.value].like! - 1,
        liked.value=false
      });
    }
  }

  void VideoInitilaize(int index) {
    final reel = Clips[index];
    Like.value = videoData[index].like;
    Index.value = index;

    videoPlayerController.value = VideoPlayerController.network(
      reel.VideoUrl,
    );
    Intialize = videoPlayerController.value
        .initialize()
        .then((value) => {Isplay.value = true});
    videoPlayerController.value.play();
    videoPlayerController.value.setVolume(1);
    videoPlayerController.value.setLooping(true);
    liked.value = false;
  }

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    VideoInitilaize(0);

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

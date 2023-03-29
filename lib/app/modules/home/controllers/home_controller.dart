import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reel_clone/app/data/reel_list.dart';
import 'package:reel_clone/utils/local_storage.dart';
import 'package:video_player/video_player.dart';

class HomeController extends GetxController {
 final user=FirebaseAuth.instance.currentUser;
  PageController pageController = PageController(initialPage: 0);
 Rx <bool> Isplay=false.obs;
  final List<Video> clips = videoPlayer;


 Rx<VideoPlayerController> videoPlayerController=VideoPlayerController.asset(videoPlayer.first.VideoId).obs;
  late Future<void> Intialize;
  void VideoInitilaize(int index) {
    final reel = clips[index];

    videoPlayerController.value = VideoPlayerController.asset(reel.VideoId);
    Intialize=videoPlayerController.value.initialize();
    videoPlayerController.value.play();
    videoPlayerController.value.setVolume(1);




  }

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    super.onInit();
    VideoInitilaize(0);


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

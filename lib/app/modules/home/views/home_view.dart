import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reel_clone/app/data/google_auth.dart';
import 'package:reel_clone/utils/local_storage.dart';
import 'package:video_player/video_player.dart';

import '../../../data/reel_list.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => PageView.builder(
          scrollDirection: Axis.vertical,
          controller: controller.pageController,
          itemCount: videoPlayer.length,
          onPageChanged: (int index) {
            controller.Isplay.value == false;
            controller.videoPlayerController.value.dispose();
            controller.VideoInitilaize(index);
          },
          itemBuilder: (BuildContext context, int index) {
            return controller.Isplay.isTrue &&
                    controller
                        .videoPlayerController.value.value.isInitialized &&
                    controller.videoPlayerController.value.value.isPlaying
                ? Container(
                    height: Get.height,
                    width: Get.width,
                    color: Colors.black,
                    child: Center(child: CircularProgressIndicator()))
                : Container(
                    height: Get.height,
                    width: Get.width,
                    color: Colors.black,
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 9 / 20,
                          child: VideoPlayer(
                              controller.videoPlayerController.value),
                        ),
                        Positioned(
                          right: 16,
                          top: 36,
                          child: IconButton(
                            onPressed: () async {
                              LocalStore.clearData();
                              print(LocalStore.getData('Photo'));
                              await GoogleAuth.signOut(context: context);
                              SystemChannels.platform
                                  .invokeMethod('SystemNavigator.pop');
                            },
                            icon: Icon(
                              Icons.logout,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                            left: 16,
                            top: 36,
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                        controller.user!.photoURL!)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    controller.user!.displayName!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}

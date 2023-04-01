import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reel_clone/app/data/firbase_database.dart';
import 'package:reel_clone/app/data/firebase_storage.dart';
import 'package:reel_clone/app/data/google_auth.dart';
import 'package:reel_clone/utils/local_storage.dart';
import 'package:video_player/video_player.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:RefreshIndicator(
          onRefresh: () async{
            videoData.clear();
            ReadData().then((value) => {
              controller.Clips.value=videoData,
              controller.VideoInitilaize(0),
            });


          },child: Obx(
          () => controller.Isplay.value == false
              ? Container(
                  height: Get.height,
                  width: Get.width,
                  color: Colors.black,
                  child: Center(child: CircularProgressIndicator()))
              :
                Obx(
                    () => PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: controller.pageController,
                      itemCount: controller.itemcount.value,
                      onPageChanged: (int index) {
                        controller.Isplay.value == false;
                        controller.itemcount.value = videoData.length;
                        controller.videoPlayerController.value.dispose();
                        controller.VideoInitilaize(index);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return videoData.isEmpty
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
                                    GestureDetector(
                                      onTap: () {
                                        if (controller.videoPlayerController.value
                                            .value.isPlaying) {
                                          controller.videoPlayerController.value
                                              .pause();
                                        } else {
                                          controller.videoPlayerController.value
                                              .play();
                                        }
                                      },
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
                                          await GoogleAuth.signOut(
                                              context: context);
                                          SystemChannels.platform.invokeMethod(
                                              'SystemNavigator.pop');
                                          FirebaseAuth.instance.currentUser!
                                              .delete();
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
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                controller.user!.displayName!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        )),
                                    Positioned(
                                      right: 16,
                                      bottom: Get.height * .15,
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        direction: Axis.vertical,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              controller.LikeAndDislike();
                                            },
                                            child: Obx(
                                              () =>
                                                  controller.liked.value == false
                                                      ? Icon(
                                                          Icons.favorite_outline,
                                                          color: Colors.white,
                                                          size: 36,
                                                        )
                                                      : Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                          size: 36,
                                                        ),
                                            ),
                                          ),
                                          Obx(
                                            () => Text(
                                              controller.Like.value.toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 16,
                                      bottom: Get.height * .10,
                                      child: Icon(
                                        Icons.comment,
                                        color: Colors.white,
                                        size: 36,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
                  ),
              ),
        ),
        bottomSheet: Container(
          width: Get.width,
          color: Colors.grey.shade900,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () {},
                    child: Text(
                      'Add Comment...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextButton(
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 24,
                          ),
                          Text(
                            "Add video",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // backgroundColor: Colors.black54,
                  onPressed: () {
                    uploadToStorage();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

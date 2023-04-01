import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reel_clone/app/data/firbase_database.dart';
import 'package:video_compress/video_compress.dart';

import 'google_auth.dart';

Future uploadToStorage() async {
  try {
    final StorageId = DateTime.now().toString();
    final metadata = SettableMetadata(contentType: 'video/mp4 ');
    XFile? PickedFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 30),
    );

    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      PickedFile!.path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false, // It's false by default
    );
    final File? file = File(mediaInfo!.path!);

    final ref = FirebaseStorage.instance.ref();
    final uploadTask = ref.child(StorageId).putFile(file!, metadata);
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          Get.snackbar('Video Uploadeding', "Upload is $progress% complete.",
              duration: Duration(milliseconds: 2000),
              backgroundColor: Colors.black,
              colorText: Colors.white);
          print(file.path);
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          GoogleAuth.customSnackBar(
            content: 'Upload Failed. Try again.',
          );
          break;
        case TaskState.success:
          Get.snackbar(
            'Video Uploaded',
            "Refresh",
            duration: Duration(milliseconds: 2000),
              backgroundColor: Colors.black,
              colorText: Colors.white
          );
          final downloadUrl = await ref.child(StorageId).getDownloadURL();
          final url = downloadUrl;
          print(url);
          firebaseDatabase.CreateData(url);
          break;
      }
    });
  } on FirebaseException catch (e) {
    GoogleAuth.customSnackBar(
      content: 'Error signing out. Try again.',
    );
    print("Failed with error '${e.code}': ${e.message}");
  }
}

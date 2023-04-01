import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:reel_clone/app/data/reel_list.dart';

class firebaseDatabase {
  static Future<void> CreateData(String url, ) async {
    await FirebaseDatabase.instance
        .ref()
        .child("Video")
        .push()
        .set({"VideoUrl": url, "like": 0,"username":[""]
        });
  }
  static Future<void> LikeData(int i,String key) async {
    DatabaseReference reference =
    await FirebaseDatabase.instance.ref().child("Video").child(key);
    reference.update({
      "like": videoData[i].like!+1,
      "username":[
        FirebaseAuth.instance.currentUser!.email
      ]

    }).then((value) => {
      videoData.clear(),
      ReadData(),

    });
  }
  static Future<void> UnlikeData(int i,String key) async {

    DatabaseReference reference =
    await FirebaseDatabase.instance.ref().child("Video").child(key);
    reference.update({
      "like": videoData[i].like!-1
    }).then((value){
      videoData.clear();
      ReadData();
      FirebaseDatabase.instance.ref().child("Video").child(key).child("username").equalTo(FirebaseAuth.instance.currentUser!.email).onChildRemoved;
    });

  }
}

List<firebaseDatabae> videoData = [];

Future<void> ReadData() async {
  DatabaseEvent reference =
      await FirebaseDatabase.instance.ref().child("Video").once();
  print(reference.snapshot.value);

  Map<dynamic, dynamic>? values = reference.snapshot.value as Map?;

  List? key = values?.keys.toList();

  for (int i = 0; i < key!.length; i++) {

    final data = values![key[i]];
   
    videoData.add(firebaseDatabae(
      id:values.keys.elementAt(i),
      VideoUrl: data['VideoUrl'],
      like: data['like'],
    ));
  }
  print('ropppp ${videoData.last.id}');
}

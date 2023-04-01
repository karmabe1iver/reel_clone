import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_clone/app/data/google_auth.dart';
import 'package:reel_clone/app/routes/app_pages.dart';
import 'package:reel_clone/utils/local_storage.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              height: Get.height * .5,
              width: Get.width * .8,
              child:   Container(
                height: Get.height * .3,
                child: Image.asset('asset/image/logo.png'),
              ),
        ),

              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Container(
              //       height: Get.height * .3,
              //       child: Image.asset('asset/image/logo.png'),
              //     ),

                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: FutureBuilder(
                      future: GoogleAuth.initializeFirebase(context: context),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error initializing Firebase');
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return
                              // _isSigningIn
                              //   ? const CircularProgressIndicator(
                              //       valueColor:
                              //           AlwaysStoppedAnimation<Color>(Colors.white),
                              //     )

                              OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              User? user = await GoogleAuth.signInWithGoogle(
                                  context: context);
                              if (user != null) {
                                LocalStore.setData('Photo', user.photoURL);
                                LocalStore.setData('Name', user.displayName);
                                Get.toNamed(Routes.HOME);
                                debugPrint(LocalStore.getData('Photo'));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: FirebaseAuth.instance.currentUser!=null
                                    ?  [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(Icons.arrow_forward_ios,
                                      color: Colors.black54,
                                      size: 24,
                                    ),
                                  )

                                ]:  [
                                        Image(
                                          image: AssetImage(
                                              'asset/image/google_logo.png'),
                                          height: 35.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Sign in with Google',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      ],

                              ),
                            ),
                          );
                        }
                        return CircularProgressIndicator();
                      },

                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

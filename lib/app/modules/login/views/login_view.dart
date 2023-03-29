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
        child: Center(
          child: Container(
            height: Get.height * .5,
            width: Get.width * .9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    offset: Offset.zero,
                    blurStyle: BlurStyle.outer,
                    blurRadius: 1.0,
                  )
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: Get.height * .3,
                  child: Image.asset('asset/image/logo.png'),
                ),
                // Text(
                //   'LOGIN',
                //   style: TextStyle(
                //       fontSize: Get.width * .06,
                //       fontWeight: FontWeight.w500,
                //       color: Colors.black),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     left: Get.width * .048,
                //     right: Get.width * .048,
                //     bottom: Get.height * .038,
                //     top: Get.height * .038,
                //   ),
                //   child: TextFormField(
                //     keyboardType: TextInputType.emailAddress,
                //     // controller: controller.emailController,
                //
                //     decoration: InputDecoration(
                //         focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //               width: 2,
                //               color: Colors.orange.shade900,
                //             ),
                //             borderRadius: BorderRadius.circular(10)),
                //         labelStyle: TextStyle(color: Colors.black),
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(10)),
                //         // prefixIcon: Image.asset(AssetHelper.emailIcon),
                //         labelText: 'Email',
                //         contentPadding: EdgeInsets.all(9),
                //         hintText: 'Email'),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //       left: Get.width * .048,
                //       right: Get.width * .048,
                //       bottom: Get.height * .038),
                //   child: TextFormField(
                //     keyboardType: TextInputType.emailAddress,
                //     decoration: InputDecoration(
                //         focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //                 width: 2, color: Colors.orange.shade900),
                //             borderRadius: BorderRadius.circular(10)),
                //         labelStyle: TextStyle(color: Colors.black),
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(10)),
                //         labelText: 'Password',
                //         contentPadding: EdgeInsets.all(9),
                //         hintText: 'Password'),
                //   ),
                // ),
                // TextButton(
                //   onPressed: () {
                //     Get.toNamed(Routes.HOME);
                //   },
                //   child: Container(
                //     width: Get.width * .3,
                //     height: Get.height * .055,
                //     decoration: BoxDecoration(
                //         color: Colors.black,
                //         borderRadius: BorderRadius.circular(10),
                //         boxShadow: [
                //           BoxShadow(
                //             offset: Offset.zero,
                //             blurStyle: BlurStyle.outer,
                //             blurRadius: 1.0,
                //           )
                //         ]),
                //     child: Center(
                //       child: Text(
                //         'Login',
                //         style: TextStyle(
                //             fontSize: Get.width * .06,
                //             fontWeight: FontWeight.w500,
                //             color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
                Spacer(),
                FutureBuilder(
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

                            LocalStore.setData('Photo',user.photoURL);
                            LocalStore.setData('Name',user.displayName);
                            Get.toNamed(Routes.HOME);
                            debugPrint(LocalStore.getData('Photo'));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Image(
                                image:
                                    AssetImage('asset/image/google_logo.png'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

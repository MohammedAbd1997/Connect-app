import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:voice_chat/Screens/AuthScreen/ui/sign_in_screen.dart';
import 'package:voice_chat/Screens/MainScreen/ui/main_screen.dart';

import '../../../Helper/SharedPreferance/shared_preferance.dart';
import '../../../Utils/CustomWidgets/custom_text.dart';
import '../../../Utils/color_constant.dart';
import '../../../Utils/images_constant.dart';
import '../../ChatScreen/view/chat_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      navigateToMain();
    });
  }

  navigateToMain() async {
    if (SpHelper.spHelper.getUserId() != "") {
      Get.offAll(() => MainScreen());
    } else {
      Get.offAll(() => SignInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CustomText(
          "CONNECT",
          fontSize: 48.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.primary,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_chat/Screens/AuthScreen/controller/auth_controller.dart';
import 'package:voice_chat/Screens/AuthScreen/ui/sign_up_screen.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_button.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_text.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_text_field.dart';
import 'package:voice_chat/Utils/color_constant.dart';
import 'package:voice_chat/Utils/images_constant.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (con) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Form(
          key: con.forgetFormKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 42.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 125.h,
                ),
                Center(
                  child: CustomText(
                    "Reset Password",
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                    color: AppColor.primary,
                  ),
                ),
                SizedBox(
                  height: 35.h,
                ),
                Center(
                  child: CustomText(
                    "An email with the reset link will be sent\n to you",
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    color: AppColor.primary,
                  ),
                ),
                SizedBox(
                  height: 31.h,
                ),
                CustomTextField(
                  hintText: "Email",
                  controller: con.emailForgetController,
                  validationFun: con.emailValidation,
                  fontsize: 18.sp,
                  borderColor: AppColor.primary,
                  prefixIcon: Image.asset(
                    Images.email,
                    width: 50.w,
                    height: 50.h,
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                CustomBotton(
                  title: "Reset",
                  height: 50.h,
                  borderRadius: 8,
                  onTap: () => con.forgetPassword(),
                  isloading: con.isLoadingForget,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

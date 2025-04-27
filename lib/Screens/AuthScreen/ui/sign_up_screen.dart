import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_chat/Screens/AuthScreen/controller/auth_controller.dart';
import 'package:voice_chat/Screens/AuthScreen/ui/sign_in_screen.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_button.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_text.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_text_field.dart';
import 'package:voice_chat/Utils/color_constant.dart';
import 'package:voice_chat/Utils/images_constant.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (con) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const SizedBox(),
        ),
        body: Form(
          key: con.signUpFormKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 42.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Center(
                  child: CustomText(
                    "Create Account",
                    fontWeight: FontWeight.w600,
                    fontSize: 28.sp,
                    color: AppColor.primary,
                  ),
                ),
                SizedBox(
                  height: 100.h,
                ),
                CustomTextField(
                  hintText: "Full Name",
                  controller: con.fullNameSignUpController,
                  validationFun: con.userNameValidator,
                  fontsize: 18.sp,
                  borderColor: AppColor.primary,
                  prefixIcon: Image.asset(
                    Images.user,
                    width: 50.w,
                    height: 50.h,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextField(
                  hintText: "Email",
                  controller: con.emailSignUpController,
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
                  height: 20.h,
                ),
                CustomTextField(
                  hintText: "Phone",
                  controller: con.phoneSignUpController,
                  validationFun: con.phoneValidation,
                  fontsize: 18.sp,
                  borderColor: AppColor.primary,
                  prefixIcon: Image.asset(
                    Images.phone,
                    width: 50.w,
                    height: 50.h,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextField(
                  hintText: "Password",
                  controller: con.passwordSignUpController,
                  validationFun: con.passwordValidator,
                  fontsize: 18.sp,
                  borderColor: AppColor.primary,
                  prefixIcon: Image.asset(
                    Images.lock,
                    width: 50.w,
                    height: 50.h,
                  ),
                  isPassword: true,
                ),
                SizedBox(
                  height: 50.h,
                ),
                CustomBotton(
                  title: "Sign Up",
                  height: 50.h,
                  borderRadius: 8,
                  onTap: () => con.signUp(),
                  isloading: con.isLoadingSignUp,
                ),
                SizedBox(
                  height: 102.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      "Already have an account?",
                      color: AppColor.primary,
                    ),
                    CustomText(
                      "Sign In",
                      color: AppColor.primary,
                      onTap: () => Get.offAll(() => SignInScreen()),
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

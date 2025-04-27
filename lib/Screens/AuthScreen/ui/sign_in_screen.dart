import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_chat/Screens/AuthScreen/controller/auth_controller.dart';
import 'package:voice_chat/Screens/AuthScreen/ui/forget_password_screen.dart';
import 'package:voice_chat/Screens/AuthScreen/ui/sign_up_screen.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_button.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_text.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_text_field.dart';
import 'package:voice_chat/Utils/color_constant.dart';
import 'package:voice_chat/Utils/images_constant.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

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
          key: con.loginFormKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 42.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100.h,
                ),
                Center(
                  child: CustomText(
                    "Welcome Back!",
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                    color: AppColor.primary,
                  ),
                ),
                SizedBox(
                  height: 100.h,
                ),
                CustomTextField(
                  hintText: "Email",
                  controller: con.emailSignInController,
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
                  hintText: "Password",
                  controller: con.passwordSignInController,
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
                  height: 4.h,
                ),
                CustomText(
                  "Forgot Password?",
                  color: AppColor.primary,
                  fontWeight: FontWeight.w600,
                  onTap: ()=>Get.to(() => ForgetPasswordScreen()),
                ),
                SizedBox(
                  height: 62.h,
                ),
                CustomBotton(
                  title: "Sign In",
                  height: 50.h,
                  borderRadius: 8,
                  onTap: () => con.signIn(),
                  isloading: con.isLoadingLogin,
                ),
                SizedBox(
                  height: 162.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      "Don't have an account?",
                      color: AppColor.primary,
                    ),
                    CustomText(
                      "Sign Up",
                      color: AppColor.primary,
                      fontWeight: FontWeight.w700,
                      onTap: () => Get.offAll(() => SignUpScreen()),
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

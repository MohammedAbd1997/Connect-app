import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_chat/Helper/SharedPreferance/shared_preferance.dart';
import 'package:voice_chat/Screens/MainScreen/ui/main_screen.dart';

class AuthController extends GetxController {
  TextEditingController emailForgetController = TextEditingController();
  TextEditingController emailSignInController = TextEditingController();
  TextEditingController passwordSignInController = TextEditingController();

  TextEditingController emailSignUpController = TextEditingController();
  TextEditingController passwordSignUpController = TextEditingController();
  TextEditingController phoneSignUpController = TextEditingController();
  TextEditingController fullNameSignUpController = TextEditingController();

  GlobalKey<FormState> forgetFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  forgetValidate() {
    bool isSuccess = forgetFormKey.currentState!.validate();
    return isSuccess;
  }

  loginValidate() {
    bool isSuccess = loginFormKey.currentState!.validate();
    return isSuccess;
  }

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  signUpValidate() {
    bool isSuccess = signUpFormKey.currentState!.validate();
    return isSuccess;
  }

  String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return "Required Field";
    }
    if (value.length < 6) {
      return 'password must be more than 6 character';
    }
    final RegExp REGEX_EMOJI = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
    if (REGEX_EMOJI.hasMatch(value)) {
      return 'password Contain Emoji';
    }
    return null;
  }

  String? emailValidation(String? value) {
    if (value!.isEmpty) {
      return "Required Field";
    }

    if (!GetUtils.isEmail(value.replaceAll(" ", ""))) {
      return 'incorrect email address';
    }
    final RegExp REGEX_EMOJI = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
    if (REGEX_EMOJI.hasMatch(value)) {
      return 'email Contain Emoji';
    }
  }

  String? userNameValidator(String? value) {
    final RegExp REGEX_EMOJI = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

    if (value!.isEmpty) {
      return 'Required Field';
    }
    if (REGEX_EMOJI.hasMatch(value)) {
      return 'Username Contain Emoji';
    }
    return null;
  }

  String? phoneValidation(String? value) {
    if (value!.isEmpty) {
      return "Required Field";
    }
    String patttern = r'(^(?:[+0]9)?[0-9]{9,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    final RegExp REGEX_EMOJI = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
    if (REGEX_EMOJI.hasMatch(value)) {
      return 'mobile number Contain Emoji';
    }
  }

  bool isLoadingLogin = false;

  signIn() async {
    if (loginValidate()) {
      if (!isLoadingLogin) {
        isLoadingLogin = true;
        update();
        try {
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailSignInController.text,
                  password: passwordSignInController.text);
          SpHelper.spHelper.setUserId(credential.user!.uid);
          Get.offAll(() => MainScreen());
          clearDataLogin();
        } on FirebaseAuthException catch (e) {
          Get.snackbar("Error", e.code.toString(), backgroundColor: Colors.red);
        }
        isLoadingLogin = false;
        update();
      }
    }
  }

  bool isLoadingForget = false;

  forgetPassword() async {
    if (forgetValidate()) {
      if (!isLoadingForget) {
        isLoadingForget = true;
        update();
        try {
          await FirebaseAuth.instance
              .sendPasswordResetEmail(email: emailForgetController.text);
          emailForgetController.clear();
          Get.back();
          Get.snackbar("Success", "reset password sent to email successfully",
              backgroundColor: Colors.green);

        } on FirebaseAuthException catch (e) {
          Get.snackbar("Error", e.code.toString(), backgroundColor: Colors.red);
        }
        isLoadingForget = false;
        update();
      }
    }
  }

  bool isLoadingSignUp = false;

  clearDataLogin() {
    emailSignInController.clear();
    passwordSignInController.clear();
  }

  clearDataSignUp() {
    emailSignUpController.clear();
    passwordSignUpController.clear();
    fullNameSignUpController.clear();
    phoneSignUpController.clear();
  }

  signUp() async {
    if (signUpValidate()) {
      if (!isLoadingSignUp) {
        isLoadingSignUp = true;
        update();
        try {
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailSignUpController.text,
            password: passwordSignUpController.text,
          );

          // 2. Save additional user data to Realtime Database
          await saveUserData(
            userId: credential.user!.uid,
            fullName: fullNameSignUpController.text,
            email: emailSignUpController.text,
            phone: phoneSignUpController.text,
          );
          SpHelper.spHelper.setUserId(credential.user!.uid);
          Get.offAll(() => MainScreen());

          clearDataSignUp();
        } on FirebaseAuthException catch (e) {
          Get.snackbar("Error", e.code.toString(), backgroundColor: Colors.red);
        } catch (e) {
          Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
        }
        isLoadingSignUp = false;
        update();
      }
    }
  }

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> saveUserData({
    required String userId,
    required String fullName,
    required String email,
    required String phone,
  }) async {
    try {
      await _dbRef.child('users').child(userId).set({
        'id': userId,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'createdAt': ServerValue.timestamp,
      });
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }
}

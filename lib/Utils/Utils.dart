import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Utils {

  static void Log(dynamic message, {String tag = "HUNTER"}) {
    log(tag + message.toString());
  }

  static void  showWrongMessage({bool isSuccess = false, bool isAlert = true, String? msg}) {
    Get.snackbar(
      isAlert
          ? "Alert".tr
          : isSuccess
          ? "Success".tr
          : "Error".tr,
      msg ?? "Somthing went Wrong try again later".tr,
      colorText: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      duration: Duration(seconds: 5),
      backgroundColor: isAlert
          ? Colors.amber
          : isSuccess
          ? Colors.green
          : Colors.red,
      icon: const Icon(Icons.add_alert),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../color_constant.dart';

class BackIconWidget extends StatelessWidget {
  const BackIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.back(),
      child: Container(

        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        width: 42.r,
        height: 42.r,
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColor.inActiveColor, width: .5)),
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: AppColor.primary,
        ),
      ),
    );
  }
}

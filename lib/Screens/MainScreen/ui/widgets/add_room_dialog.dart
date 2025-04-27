import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_chat/Screens/MainScreen/controller/main_controller.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_button.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_text.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_text_field.dart';
import 'package:voice_chat/Utils/color_constant.dart';

class AddRoomDialog extends StatelessWidget {
  const AddRoomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(builder: (con) {
      return Form(
        key: con.formKey,
        child: Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  "Create Room",
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: AppColor.primary,
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextField(
                    hintText: "Room name",
                    controller: con.roomNameController,
                    validationFun: con.nullValidator),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomBotton(
                        title: "Create",
                        style: TextStyle(fontSize: 16.sp),
                        onTap: () => con.createRoom(),
                        isloading: con.isLoading,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: CustomBotton(
                        title: "Cancel",
                        style: TextStyle(fontSize: 16.sp),
                        backgroundColor: Colors.grey,
                        onTap: () => Get.back(),
                      ),
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

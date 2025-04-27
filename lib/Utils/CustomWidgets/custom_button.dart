import 'package:flutter/material.dart';

import '../color_constant.dart';
import 'custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBotton extends StatelessWidget {
  VoidCallback? onTap;
  double? height;
  double? width;
  Color? backgroundColor;
  Color? borderColor;
  String? title;
  TextStyle? style;
  double? borderRadius;
  Gradient? gradient;
  List<BoxShadow>? boxShadow = [];
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  bool? isloading;

  CustomBotton(
      {this.onTap,
      this.height = 50,
      this.width,
      this.margin,
      this.padding,
      this.gradient,
      this.backgroundColor,
      this.title,
      this.boxShadow,
      this.style,
      this.isloading = false,
      this.borderColor = Colors.transparent,
      this.borderRadius = 15});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin ?? EdgeInsets.zero,
        padding: padding ?? EdgeInsets.zero,
        alignment: Alignment.center,
        height: height!.h,
        width: width,
        decoration: BoxDecoration(
            gradient: gradient,
            color: backgroundColor ?? AppColor.primary,
            boxShadow: boxShadow,
            border: Border.all(color: borderColor!, width: 1),
            borderRadius: BorderRadius.circular(borderRadius!)),
        child: isloading!
            ? SizedBox(
                width: height!.h - 5,
                height: height!.h - 5,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: style == null ? Colors.white : style!.color,
                ),
              )
            : CustomText(
                title!,
                color: style?.color ?? Colors.white,
                fontWeight: style?.fontWeight ?? FontWeight.w500,
                fontSize: style?.fontSize ?? 24.sp,
              ),
      ),
    );
  }
}

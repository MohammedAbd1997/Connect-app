import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  String text;
  double? fontSize;
  double? letterSpacing;
  FontWeight? fontWeight;
  TextAlign? textAlign;
  int? maxLines;
  Color? color;
  double? height;
  VoidCallback? onTap;
  TextDecoration? decoration;

  CustomText(this.text,
      {this.fontSize,
      this.letterSpacing,
      this.fontWeight,
      this.textAlign,
      this.maxLines,
      this.color = Colors.black,
      this.height,
      this.onTap,
      this.decoration});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        maxLines: maxLines,
        style: TextStyle(
            decoration: decoration ?? TextDecoration.none,
            color: color,
            overflow: maxLines == null ? null : TextOverflow.ellipsis,
            decorationColor: color,
            height: height,
            letterSpacing: letterSpacing,
            fontSize: fontSize ?? 14.sp,
            fontWeight: fontWeight ?? FontWeight.w400),
        // style: GoogleFonts.roboto(
        //     decoration: decoration ?? TextDecoration.none,
        //     color: color,
        //     textStyle: TextStyle(
        //       overflow: maxLines == null ? null : TextOverflow.ellipsis,
        //     ),
        //     decorationColor: color,
        //     height: height,
        //     letterSpacing: letterSpacing,
        //     fontSize: fontSize ?? 14.sp,
        //     fontWeight: fontWeight ?? FontWeight.w400),
        textAlign: textAlign ?? TextAlign.start,
      ),
    );
  }
}

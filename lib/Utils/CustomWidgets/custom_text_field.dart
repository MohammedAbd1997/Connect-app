import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../color_constant.dart';

class CustomTextField extends StatefulWidget {
  bool isPassword = false;
  final String hintText;
  Function(String?)? onChange;
  Widget? suffixIcon;
  Widget? prefixIcon;
  TextEditingController? controller;
  Color? fillColor = Colors.black;
  Color? textColor = Colors.black;
  Color? borderColor;

  bool? filled = false;
  bool? enable = true;
  bool? autofocus = false;
  double? borderRadius;
  double? paddingH;
  double? paddingV;

  double? fontsize = 14.sp;
  FontWeight? fontWeight;
  AutovalidateMode? autovalidateMode;
  int? maxLines;
  int? maxLength;
  String? Function(String? val)? validationFun;
  TextInputType textInputType;
  TextAlign? textAlign;

  CustomTextField(
      {this.onChange,
      required this.hintText,
      required this.controller,
      this.isPassword = false,
      this.suffixIcon,
      this.autovalidateMode = AutovalidateMode.disabled,
      this.prefixIcon,
      this.fillColor,
      this.textColor,
      this.borderColor = Colors.transparent,
      this.filled,
      this.enable,
      this.autofocus = false,
      this.fontsize,
      this.borderRadius = 8,
      this.paddingH = 9,
      this.paddingV = 6,
      this.maxLines = 1,
      this.maxLength,
      this.validationFun,
      this.fontWeight,
      this.textAlign = TextAlign.start,
      this.textInputType = TextInputType.text});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isHiden = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChange,
      autofocus: widget.autofocus!,
      textAlignVertical: TextAlignVertical.center,
      autovalidateMode: widget.autovalidateMode,
      keyboardType: widget.textInputType,
      validator: widget.validationFun,
      maxLength: widget.maxLength,
      style: TextStyle(
          color: widget.textColor,
          fontSize: widget.fontsize,
          fontWeight: widget.fontWeight,
          height: 1.9),
      enabled: widget.enable,
      maxLines: widget.maxLines!,
      controller: widget.controller,
      textAlign: widget.textAlign!,

      cursorColor: AppColor.secondary,
      cursorHeight: 20,

      decoration: InputDecoration(
          filled: widget.filled,
          fillColor: widget.fillColor,
          contentPadding: EdgeInsets.symmetric(
              horizontal: widget.paddingH!, vertical: widget.paddingV!),
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: widget.prefixIcon)
              : null,
          prefixIconConstraints:
              BoxConstraints(maxWidth: 40.r, maxHeight: 50.r),
          suffixIconConstraints:
              BoxConstraints(maxWidth: 40.r, maxHeight: 20.r),
          suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: widget.isPassword
                  ? isHiden
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              isHiden = !isHiden;
                            });
                          },
                          child: const Icon(
                            Icons.visibility,
                            color: AppColor.primary,
                            size: 19,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              isHiden = !isHiden;
                            });
                          },
                          child: const Icon(Icons.visibility_off,
                              color: AppColor.primary, size: 19))
                  : widget.suffixIcon),
          errorStyle: const TextStyle(color: Colors.red),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: (widget.borderColor ?? Colors.grey).withOpacity(0.6),
                  width: 1.5.w)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: (widget.borderColor ?? Colors.grey).withOpacity(0.6),
                  width: 1.5.w)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide:
                  BorderSide(color: Colors.red.withOpacity(0.6), width: 1.5.w)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide:
                  BorderSide(color: Colors.red.withOpacity(0.6), width: 1.5.w)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: (widget.borderColor ?? Colors.grey).withOpacity(0.6),
                  width: 1.5.w)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
            borderSide: BorderSide(
                color: (widget.borderColor ?? Colors.grey).withOpacity(0.6),
                width: 1.5.w),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColor.primary,
              fontSize: widget.fontsize)),

      obscureText: widget.isPassword
          ? isHiden
              ? false
              : true
          : widget.isPassword,

      //  onChanged: (value){},
    );
  }
}

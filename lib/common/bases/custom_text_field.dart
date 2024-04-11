import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.textInputType,
    required this.obscureText,
    required this.suffixIcon,
    required this.hintText,
    this.validator,
    this.onSaved,
    this.onChanged,
    required this.prefixIcon,
    required this.readOnly,
  });

  final TextEditingController controller;
  final TextInputType textInputType;
  final bool obscureText;
  final IconButton suffixIcon;
  final String hintText;
  final String? Function(String?)? validator; // Specify the type here
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final Icon prefixIcon;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      readOnly: readOnly,
      controller: controller,
      keyboardType: textInputType,
      style:  TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.normal,
          fontSize: 13.sp),
        
      obscureText: obscureText,
      decoration: InputDecoration(
        labelStyle:  TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.normal,
          fontSize: 13.sp),
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1.w, color: AppColors.primaryButton),
              borderRadius: BorderRadius.all(Radius.circular(15.0.r))),
          contentPadding: EdgeInsets.all(20.r),
          suffixIcon: suffixIcon,
          labelText: hintText, // change here hinttext
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
              borderSide:
                  BorderSide(width: 1.w, color: AppColors.secondaryText)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
            borderSide: BorderSide(width: 1.w, color: AppColors.primaryButton),
          )),
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
    );
  }
}

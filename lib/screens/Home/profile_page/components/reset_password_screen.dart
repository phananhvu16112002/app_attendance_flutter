import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text_field.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RegExp upperCaseRegex = RegExp(r'[A-Z]');
  RegExp digitRegex = RegExp(r'[0-9]');
  bool isCheckPassword = true;
  bool isCheckConfirmPassword = true;
  bool isCheckOldPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: AppColors.primaryText)),
        centerTitle: false,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          message: 'Old Password',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      8.verticalSpace,
                      CustomTextField(
                        readOnly: false,
                        controller: oldPassword,
                        textInputType: TextInputType.visiblePassword,
                        obscureText: isCheckOldPassword,
                        prefixIcon: const Icon(null),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isCheckOldPassword = !isCheckOldPassword;
                              });
                            },
                            icon: isCheckOldPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off)),
                        hintText: 'Enter your old password',
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Old Password is required';
                          }
                          return null;
                        },
                      ),
                      10.verticalSpace,
                      CustomText(
                          message: 'New Password',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      8.verticalSpace,
                      CustomTextField(
                        readOnly: false,
                        controller: newPassword,
                        textInputType: TextInputType.visiblePassword,
                        obscureText: isCheckPassword,
                        prefixIcon: const Icon(null),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isCheckPassword = !isCheckPassword;
                              });
                            },
                            icon: isCheckPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off)),
                        hintText: 'Enter your new password',
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          if (!upperCaseRegex.hasMatch(value)) {
                            return 'Password must be contain at least one uppercase letter';
                          }
                          if (!digitRegex.hasMatch(value)) {
                            return 'Password must be contain at least one digit number';
                          }
                          return null;
                        },
                      ),
                      10.verticalSpace,
                      CustomText(
                          message: 'Confirm Password',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      8.verticalSpace,
                      CustomTextField(
                        readOnly: false,
                        controller: confirmPassword,
                        textInputType: TextInputType.visiblePassword,
                        obscureText: isCheckConfirmPassword,
                        prefixIcon: const Icon(null),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isCheckConfirmPassword =
                                    !isCheckConfirmPassword;
                              });
                            },
                            icon: isCheckConfirmPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off)),
                        hintText: 'Enter your confirm password',
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm Password is required';
                          }
                          if (value != newPassword.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        },
                      ),
                      20.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: CustomButton(
                buttonName: 'Reset Password',
                backgroundColorButton: AppColors.primaryButton,
                borderColor: Colors.transparent,
                textColor: Colors.white,
                function: () {
                  if (_formKey.currentState!.validate()) {
                    print('sss');
                  } else {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                          duration: const Duration(milliseconds: 1000),
                          backgroundColor: Colors.white,
                          content: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffa8a8a8),
                                borderRadius: BorderRadius.circular(8.r)),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Center(
                              child: Text(
                                'Please check your password',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                            ),
                          )));
                  }
                },
                fontSize: 18.sp,
                colorShadow: Colors.white),
          ),
          SizedBox(
            height: 10.h,
          )
        ],
      ),
    );
  }
}

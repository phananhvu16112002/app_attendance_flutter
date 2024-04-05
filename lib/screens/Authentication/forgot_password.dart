import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text_field.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/forgot_password_otp_page.dart';
import 'package:attendance_system_nodejs/services/authentication_services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String description =
      "Don’t worry! If occurs. Please enter your email address or mobile number linked with your account!";
  TextEditingController emailAddress = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late ProgressDialog _progressDialog;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _progressDialog = ProgressDialog(context,
        customBody: Container(
          width: 200,
          height: 150,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white),
          child: const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.primaryButton,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Loading',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final studentDataProvider = Provider.of<StudentDataProvider>(context);

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/forgot.png'),
          Container(
            child: Padding(
              padding:  EdgeInsets.only(top: 15.h, left: 20.w, right: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     CustomText(
                        message: 'Forgot Your Password?',
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    10.verticalSpace,
                    CustomText(
                        message: description,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryText),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    15.verticalSpace,
                     CustomText(
                        message: "Email",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    10.verticalSpace,
                    CustomTextField(
                      controller: emailAddress,
                      readOnly: false,
                      textInputType: TextInputType.emailAddress,
                      obscureText: false,
                      prefixIcon: const Icon(null),
                      suffixIcon:
                          IconButton(onPressed: () {}, icon: const Icon(null)),
                      hintText: 'Enter your email address',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        final RegExp tdtuEmailExp = RegExp(
                            r'^[0-9A-Z]+@(student\.)?tdtu\.edu\.vn$',
                            caseSensitive: false);
                        if (!tdtuEmailExp.hasMatch(value)) {
                          return 'Please check your valid email TDTU';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        studentDataProvider.setStudentEmail(value);
                      },
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    15.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(right: 0, left: 0),
                      child: CustomButton(
                          fontSize: 18.sp,
                          // height: 60,
                          // width: 400,
                          buttonName: "Send OTP",
                          colorShadow: Colors.transparent,
                          backgroundColorButton: AppColors.primaryButton,
                          borderColor: Colors.white,
                          textColor: Colors.white,
                          function: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                _progressDialog.show();
                                String check = await Authenticate()
                                    .forgotPassword(emailAddress.text);
                                if (check == '') {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              const ForgotPasswordOTPPage()));
                                  await _progressDialog.hide();
                                  showFlushBarNotification(
                                      context,
                                      'Verify OTP',
                                      'OTP has been sent to your email',
                                      3);
                                } else {
                                  await _progressDialog.hide();
                                  showFlushBarNotification(
                                      context, 'Failed', check, 3);
                                }
                              } catch (e) {
                                print(e);
                              } finally {
                                await _progressDialog.hide();
                              }
                            }
                          }),
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         CustomText(
                            message: 'Already have an account ? ',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryText),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/Login", (route) => false);
                          },
                          child:  CustomText(
                              message: 'Log In',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.importantText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // const SizedBox(height: 20,),
          20.verticalSpace
        ],
      ),
    ));
  }

  void showFlushBarNotification(
      BuildContext context, String title, String message, int second) {
    Flushbar(
      title: title,
      message: message,
      duration: Duration(seconds: second),
    ).show(context);
  }
}

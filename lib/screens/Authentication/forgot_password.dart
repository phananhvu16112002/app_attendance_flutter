import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text_field.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/forgot_password_otp_page.dart';
import 'package:attendance_system_nodejs/screens/Authentication/sign_in_page.dart';
import 'package:attendance_system_nodejs/services/authentication_services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          width: double.infinity,
          height: 150.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              color: Colors.white),
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: AppColors.primaryButton,
              ),
              5.verticalSpace,
              Text(
                 'Loading',
                style: TextStyle(
                    fontSize: 16.sp,
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
              padding: EdgeInsets.only(top: 15.h, left: 20.w, right: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        message: AppLocalizations.of(context)
                                ?.forgot_your_password ??
                            'Forgot Your Password?',
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    10.verticalSpace,
                    CustomText(
                        message: AppLocalizations.of(context)
                                ?.forgot_password_message ??
                            description,
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
                      hintText: AppLocalizations.of(context)?.email_field ??
                          'Enter your email address',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)?.title_email_required ?? 'Email is required';
                        }
                        final RegExp tdtuEmailExp = RegExp(
                            r'^[0-9A-Z]+@(student\.)?tdtu\.edu\.vn$',
                            caseSensitive: false);
                        if (!tdtuEmailExp.hasMatch(value)) {
                          return AppLocalizations.of(context)?.title_email_tdtu ?? 'Please check your valid email TDTU';
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
                          buttonName: AppLocalizations.of(context)?.send_otp ??
                              "Send OTP",
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
                                      AppLocalizations.of(context)?.otp_verification ?? 'Verify OTP',
                                      AppLocalizations.of(context)?.subT_resend_otp?? 'OTP has been sent to your email',
                                      3);
                                } else {
                                  await _progressDialog.hide();
                                  showFlushBarNotification(
                                      context,AppLocalizations.of(context)?.title_failed ?? 'Failed', check, 3);
                                }
                              } catch (e) {
                                await _progressDialog.hide();
                                print(e);
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
                            message:
                                AppLocalizations.of(context)?.login_account ??
                                    'Already have an account ? ',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryText),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => SignInPage()),
                                (route) => false);
                          },
                          child: CustomText(
                              message: AppLocalizations.of(context)?.login ??
                                  'Log In',
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

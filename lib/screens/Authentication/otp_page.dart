import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/sign_in_page.dart';
import 'package:attendance_system_nodejs/services/authentication_services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  OtpFieldController otpController = OtpFieldController();
  String description =
      "Please enter the verification code we just sent on your email address.";
  int secondsRemaining = 59;
  bool canResend = false;
  late Timer _timer;
  late ProgressDialog _progressDialog;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _progressDialog = ProgressDialog(context,
        isDismissible: false,
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
    startTimer();
  }

  void restartTimer() {
    setState(() {
      secondsRemaining = 60;
      canResend = false;
    });
    startTimer(); // Start the timer again
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('OTP dispose');
    _timer.cancel();
    super.dispose();
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
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        message: "OTP Verification",
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
                    //   height: 20,
                    // ),
                    20.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: OTPTextField(
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: otpController,
                        textFieldAlignment: MainAxisAlignment.spaceEvenly,
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        outlineBorderRadius: 10.r,
                        fieldWidth: 45.w,
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w500),
                        fieldStyle: FieldStyle.box,
                        onChanged: (pin) {
                          studentDataProvider.setHashedOTP(pin);
                        },
                      ),
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    20.verticalSpace,
                    CustomButton(
                        fontSize: 18.sp,
                        // height: 60,
                        // width: 400,
                        buttonName: "Verify",
                        colorShadow: Colors.transparent,
                        backgroundColorButton: AppColors.primaryButton,
                        borderColor: Colors.white,
                        textColor: Colors.white,
                        function: () async {
                          try {
                            _progressDialog.show();
                            bool checkLogin = await Authenticate().verifyOTP(
                                studentDataProvider.userData.studentEmail,
                                studentDataProvider.userData.hashedOTP);
                            // bool checkLogin = await Authenticate().verifyOTP(
                            //     studentDataProvider.userData.studentEmail,
                            //     otpController.toString());
                            if (checkLogin == true) {
                              // ignore: use_build_context_synchronously
                              await Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SignInPage(),
                                  transitionDuration:
                                      const Duration(milliseconds: 1000),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    var curve = Curves.easeInOutCubic;
                                    var tween = Tween(
                                            begin: const Offset(1.0, 0.0),
                                            end: Offset.zero)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                                (route) => false,
                              );
                              await _progressDialog.hide();
                              await Flushbar(
                                title: "Successfully",
                                message: "Login to use the app",
                                duration: const Duration(seconds: 5),
                              ).show(context);
                            } else {
                              await _progressDialog.hide();
                              await Flushbar(
                                title: "Failed",
                                message: "OTP is not valid",
                                duration: const Duration(seconds: 5),
                              ).show(context);
                            }
                          } catch (e) {
                            print(e);
                          } finally {
                            await _progressDialog.hide();
                          }
                        }),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    15.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                              message: "Didn't recieved code ? ",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText),
                          GestureDetector(
                            onTap: () async {
                              if (canResend) {
                                _progressDialog.show();
                                bool check = await Authenticate()
                                    .resendOTPRegister(studentDataProvider
                                        .userData.studentEmail);
                                if (check) {
                                  // ignore: use_build_context_synchronously
                                  restartTimer();
                                  await _progressDialog.hide();
                                  showFlushBarNotification(
                                      context,
                                      'Resend OTP',
                                      "OTP has been sent your email",
                                      3);
                                } else {
                                  // ignore: use_build_context_synchronously
                                  showFlushBarNotification(context,
                                      'Failed resend OTP', 'message', 3);
                                }
                              }
                            },
                            child: CustomText(
                                message: canResend
                                    ? "Re-send"
                                    : "Resend in $secondsRemaining seconds",
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.importantText),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          canResend = true;
        });
        timer.cancel();
      }
    });
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

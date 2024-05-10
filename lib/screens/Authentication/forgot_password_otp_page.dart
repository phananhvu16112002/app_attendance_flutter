import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/create_new_password.dart';
import 'package:attendance_system_nodejs/services/authentication_services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordOTPPage extends StatefulWidget {
  const ForgotPasswordOTPPage({super.key});

  @override
  State<ForgotPasswordOTPPage> createState() => _ForgotPasswordOTPPageState();
}

class _ForgotPasswordOTPPageState extends State<ForgotPasswordOTPPage> {
  OtpFieldController otpController = OtpFieldController();
  String description =
      "Please enter the verification code we just sent on your email address.";
  int secondsRemaining = 5; // Initial value for 1 minute
  bool canResend = false;
  late ProgressDialog _progressDialog;
  late Timer _timer;

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
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('Forgot dispose');
    _timer.cancel();
    super.dispose();
  }

  void restartTimer() {
    setState(() {
      secondsRemaining = 5;
      canResend = false;
    });
    startTimer(); // Start the timer again
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
                padding: EdgeInsets.only(top: 15.h, left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        message:
                            AppLocalizations.of(context)?.otp_verification ??
                                "OTP Verification",
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    10.verticalSpace,
                    CustomText(
                        message: AppLocalizations.of(context)
                                ?.otp_verification_message ??
                            description,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryText),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    20.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
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
                            fontSize: 13.sp, fontWeight: FontWeight.w500),
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
                    Padding(
                      padding: EdgeInsets.only(right: 18.0),
                      child: CustomButton(
                          fontSize: 20.sp,
                          // height: 60,
                          // width: 400,
                          buttonName:
                              AppLocalizations.of(context)?.verify ?? "Verify",
                          colorShadow: Colors.transparent,
                          backgroundColorButton: AppColors.primaryButton,
                          borderColor: Colors.white,
                          textColor: Colors.white,
                          function: () async {
                            bool check = await Authenticate()
                                .verifyForgotPassword(
                                    studentDataProvider.userData.studentEmail,
                                    studentDataProvider.userData.hashedOTP);
                            if (check) {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const CreateNewPassword(),
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
                              );
                              Flushbar(
                                title: AppLocalizations.of(context)
                                        ?.title_successfully ??
                                    "Successfully",
                                message: AppLocalizations.of(context)
                                        ?.please_create_new_password ??
                                    "Login to use the app",
                                duration: const Duration(seconds: 5),
                              ).show(context);
                            } else {
                               Flushbar(
                                title: AppLocalizations.of(context)
                                        ?.title_failed ??
                                    "Failed",
                                message: AppLocalizations.of(context)
                                        ?.title_otp_invalid ??
                                    "OTP is not valid",
                                duration: const Duration(seconds: 5),
                              ).show(context);
                              // print('Failed');
                            }
                            //   try {
                            //   _progressDialog.show();
                            //   bool checkLogin = await Authenticate().verifyForgotPassword(
                            //       studentDataProvider.userData.studentEmail,
                            //       studentDataProvider.userData.hashedOTP);
                            //   // bool checkLogin = await Authenticate().verifyOTP(
                            //   //     studentDataProvider.userData.studentEmail,
                            //   //     otpController.toString());
                            //   if (checkLogin == true) {
                            //     // ignore: use_build_context_synchronously
                            //     await Navigator.pushAndRemoveUntil(
                            //       context,
                            //       PageRouteBuilder(
                            //         pageBuilder: (context, animation,
                            //                 secondaryAnimation) =>
                            //             const CreateNewPassword(),
                            //         transitionDuration:
                            //             const Duration(milliseconds: 1000),
                            //         transitionsBuilder: (context, animation,
                            //             secondaryAnimation, child) {
                            //           var curve = Curves.easeInOutCubic;
                            //           var tween = Tween(
                            //                   begin: const Offset(1.0, 0.0),
                            //                   end: Offset.zero)
                            //               .chain(CurveTween(curve: curve));
                            //           var offsetAnimation =
                            //               animation.drive(tween);
                            //           return SlideTransition(
                            //             position: offsetAnimation,
                            //             child: child,
                            //           );
                            //         },
                            //       ),
                            //       (route) => false,
                            //     );
                            //     await _progressDialog.hide();
                            //     await Flushbar(
                            //       title: AppLocalizations.of(context)
                            //               ?.title_successfully ??
                            //           "Successfully",
                            //       message: AppLocalizations.of(context)
                            //               ?.title_success_otp ??
                            //           "Login to use the app",
                            //       duration: const Duration(seconds: 5),
                            //     ).show(context);
                            //   } else {
                            //     await _progressDialog.hide();
                            //     await Flushbar(
                            //       title: AppLocalizations.of(context)
                            //               ?.title_failed ??
                            //           "Failed",
                            //       message: AppLocalizations.of(context)
                            //               ?.title_otp_invalid ??
                            //           "OTP is not valid",
                            //       duration: const Duration(seconds: 5),
                            //     ).show(context);
                            //   }
                            // } catch (e) {
                            //   print(e);
                            // } finally {
                            //   await _progressDialog.hide();
                            // }
                          }),
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    15.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                              message: AppLocalizations.of(context)
                                      ?.resend_message ??
                                  "Didn't recieved code ? ",
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText),
                          GestureDetector(
                            onTap: () async {
                              // _progressDialog.show();

                              if (canResend) {
                                _progressDialog.show();
                                String check = await Authenticate().resendOTP(
                                    studentDataProvider.userData.studentEmail);
                                if (check.isEmpty || check == '') {
                                  restartTimer();
                                  // await _progressDialog.hide();
                                  showFlushBarNotification(
                                      context,
                                      AppLocalizations.of(context)
                                              ?.title_resend_otp ??
                                          'Resend OTP',
                                      AppLocalizations.of(context)
                                              ?.subT_resend_otp ??
                                          "OTP has been sent your email",
                                      3);
                                } else {
                                  // ignore: use_build_context_synchronously
                                  showFlushBarNotification(
                                      context,
                                      AppLocalizations.of(context)
                                              ?.title_failed ??
                                          'Failed resend OTP',
                                      AppLocalizations.of(context)
                                              ?.subT_resend_otp_1 ??
                                          'Please try again!',
                                      3);
                                }
                              }
                              // if (canResend) {
                              //   _progressDialog.show();
                              //   String check = await Authenticate().resendOTP(
                              //       studentDataProvider.userData.studentEmail);
                              //   if (check == '') {
                              //     restartTimer();
                              //     await _progressDialog.hide();
                              //     // ignore: use_build_context_synchronously
                              //     showFlushBarNotification(
                              //         context,
                              //         AppLocalizations.of(context)
                              //                 ?.title_resend_otp ??
                              //             'Resend OTP',
                              //         AppLocalizations.of(context)
                              //                 ?.subT_resend_otp ??
                              //             "OTP has been sent your email",
                              //         3);
                              //   } else {
                              //     await _progressDialog.hide();
                              //     // ignore: use_build_context_synchronously
                              //     showFlushBarNotification(
                              //         context,
                              //         AppLocalizations.of(context)
                              //                 ?.title_failed ??
                              //             'Failed resend OTP',
                              //         AppLocalizations.of(context)
                              //                 ?.subT_resend_otp_1 ??
                              //             'Please try again',
                              //         3);
                              //   }
                              // }
                            },
                            child: CustomText(
                                message: canResend
                                    ? AppLocalizations.of(context)
                                            ?.title_resend ??
                                        "Re-send"
                                    : "${AppLocalizations.of(context)?.title_resend_in ?? 'Resend in'} $secondsRemaining ${AppLocalizations.of(context)?.seconds ?? 'seconds'}",
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

  // void startTimer() {
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (secondsRemaining > 0) {
  //         secondsRemaining--;
  //       } else {
  //         canResend = true;
  //         timer.cancel(); // Stop the timer when it reaches 0
  //       }
  //     });
  //   });

  //   // Disable the button during the countdown
  //   setState(() {
  //     canResend = false;
  //     secondsRemaining = 60; // Reset the timer to 1 minute
  //   });
  // }

  // void startTimer() {
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (secondsRemaining > 0) {
  //       setState(() {
  //         secondsRemaining--;
  //       });
  //     } else {
  //       setState(() {
  //         canResend = true;
  //       });
  //       timer.cancel(); // Stop the timer when it reaches 0
  //     }
  //   });
  // }

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

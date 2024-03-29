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
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class ForgotPasswordOTPPage extends StatefulWidget {
  const ForgotPasswordOTPPage({super.key});

  @override
  State<ForgotPasswordOTPPage> createState() => _ForgotPasswordOTPPageState();
}

class _ForgotPasswordOTPPageState extends State<ForgotPasswordOTPPage> {
  OtpFieldController otpController = OtpFieldController();
  String description =
      "Please enter the verification code we just sent on your email address.";
  int secondsRemaining = 10; // Initial value for 1 minute
  bool canResend = false;
  late ProgressDialog _progressDialog;
  late Timer _timer;

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
      secondsRemaining = 10;
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
                padding: const EdgeInsets.only(top: 15, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                        message: "OTP Verification",
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                        message: description,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryText),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: OTPTextField(
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: otpController,
                        textFieldAlignment: MainAxisAlignment.spaceEvenly,
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        outlineBorderRadius: 10,
                        fieldWidth: 50,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        fieldStyle: FieldStyle.box,
                        onChanged: (pin) {
                          studentDataProvider.setHashedOTP(pin);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        fontSize: 20,
                        height: 60,
                        width: 400,
                        buttonName: "Verify",
                        colorShadow: AppColors.colorShadow,
                        backgroundColorButton: AppColors.primaryButton,
                        borderColor: Colors.white,
                        textColor: Colors.white,
                        function: () async {
                          try {
                            _progressDialog.show();
                            bool checkLogin = await Authenticate()
                                .verifyForgotPassword(
                                    studentDataProvider.userData.studentEmail,
                                    studentDataProvider.userData.hashedOTP);
                            if (checkLogin == true) {
                              // ignore: use_build_context_synchronously
                              await Navigator.pushAndRemoveUntil(
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
                                (route) => false,
                              );
                              await _progressDialog.hide();
                              // ignore: use_build_context_synchronously
                              await Flushbar(
                                title: "Successfully",
                                message: "Create new password",
                                duration: const Duration(seconds: 5),
                              ).show(context);
                            } else {
                              await _progressDialog.hide();
                              // ignore: use_build_context_synchronously
                              Flushbar(
                                title: "Failed",
                                message: "OTP is not valid",
                                duration: const Duration(seconds: 5),
                              ).show(context);
                            }
                          } catch (e) {
                            // ignore: avoid_print
                            await _progressDialog.hide();
                            print(e);
                          } finally {
                            await _progressDialog.hide();
                          }
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CustomText(
                              message: "Didn't recieved code ? ",
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText),
                          GestureDetector(
                            onTap: () async {
                              if (canResend) {
                                _progressDialog.show();
                                String check = await Authenticate().resendOTP(
                                    studentDataProvider.userData.studentEmail);
                                if (check == '') {
                                  restartTimer();
                                  await _progressDialog.hide();
                                  // ignore: use_build_context_synchronously
                                  showFlushBarNotification(
                                      context,
                                      'Resend OTP',
                                      "OTP has been sent your email",
                                      3);
                                } else {
                                  await _progressDialog.hide();
                                  // ignore: use_build_context_synchronously
                                  showFlushBarNotification(context,
                                      'Failed resend OTP', 'message', 3);
                                }
                              }
                            },
                            child: CustomText(
                                message: canResend // true
                                    ? "Re-send"
                                    : "Resend in $secondsRemaining seconds",
                                fontSize: 15,
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

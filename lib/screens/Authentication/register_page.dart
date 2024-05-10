import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text_field.dart';
import 'package:attendance_system_nodejs/common/bases/image_slider.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/otp_page.dart';
import 'package:attendance_system_nodejs/screens/Authentication/sign_in_page.dart';
import 'package:attendance_system_nodejs/services/authentication_services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController username = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool isCheckPassword = true;
  bool isCheckConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  RegExp upperCaseRegex = RegExp(r'[A-Z]');
  RegExp digitRegex = RegExp(r'[0-9]');
  late ProgressDialog _progressDialog;

  bool isTDTUEmail(String email) {
    // Biểu thức chính quy để kiểm tra phần sau ký tự '@'
    final RegExp tdtuEmailRegExp =
        RegExp(r'^[0-9A-Z]+@(student\.)?tdtu\.edu\.vn$', caseSensitive: false);

    return tdtuEmailRegExp.hasMatch(email);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _progressDialog = ProgressDialog(context,
        isDismissible: false,
        customBody: Container(
          width: 200.w,
          height: 150.h,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white),
          child: Center(
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
                    fontSize: 14.sp,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    emailAddress.dispose();
    password.dispose();
    confirmPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentDataProvider = Provider.of<StudentDataProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImageSlider(),
            Container(
                child: Padding(
              padding: EdgeInsets.only(left: 20.w, top: 15.h, right: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          message: AppLocalizations.of(context)?.register ??
                              'Register',
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      5.verticalSpace,
                      CustomText(
                          message:
                              AppLocalizations.of(context)?.register_message ??
                                  'Enter your personal information',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryText),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      20.verticalSpace,
                      CustomText(
                          message:
                              AppLocalizations.of(context)?.studentID_field ??
                                  'Student ID',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      10.verticalSpace,
                      CustomTextField(
                        readOnly: false,
                        controller: username,
                        textInputType: TextInputType.text,
                        obscureText: false,
                        prefixIcon: const Icon(null),
                        suffixIcon:
                            const IconButton(onPressed: null, icon: Icon(null)),
                        hintText: AppLocalizations.of(context)
                                ?.studentID_field_message ??
                            'Enter your student ID',
                        onChanged: (value) {
                          studentDataProvider.setStudentName(value);
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length > 50) {
                            return '${AppLocalizations.of(context)?.title_check_student_id}(${AppLocalizations.of(context)?.title_check_student_id_1}) ';
                          }
                          return null;
                        },
                      ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      15.verticalSpace,
                      CustomText(
                          message: 'Email',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      10.verticalSpace,
                      CustomTextField(
                        readOnly: false,
                        controller: emailAddress,
                        textInputType: TextInputType.emailAddress,
                        obscureText: false,
                        prefixIcon: const Icon(null),
                        suffixIcon:
                            const IconButton(onPressed: null, icon: Icon(null)),
                        hintText: AppLocalizations.of(context)?.email_field ??
                            'Enter your email',
                        onChanged: (value) {
                          studentDataProvider.setStudentEmail(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)
                                    ?.title_email_required ??
                                'Email is required';
                          }
                          final RegExp tdtuEmailExp = RegExp(
                              r'^[0-9A-Z]+@(student\.)?tdtu\.edu\.vn$',
                              caseSensitive: false);
                          if (!tdtuEmailExp.hasMatch(value)) {
                            return AppLocalizations.of(context)
                                    ?.title_email_tdtu ??
                                'Please check your valid email TDTU';
                          }
                          return null;
                        },
                      ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      15.verticalSpace,
                      CustomText(
                        message: AppLocalizations.of(context)?.password ??
                            'Password',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      10.verticalSpace,
                      CustomTextField(
                        readOnly: false,
                        controller: password,
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
                        hintText:
                            AppLocalizations.of(context)?.password_field ??
                                'Enter your password',
                        onChanged: (value) {
                          studentDataProvider.setPassword(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)
                                    ?.title_password_required ??
                                'Password is required';
                          }
                          if (value.length < 8) {
                            return AppLocalizations.of(context)
                                    ?.title_check_password_1 ??
                                'Password must be at least 8 characters long';
                          }
                          if (!upperCaseRegex.hasMatch(value)) {
                            return AppLocalizations.of(context)
                                    ?.title_check_password_2 ??
                                'Password must be contain at least one uppercase letter';
                          }
                          if (!digitRegex.hasMatch(value)) {
                            return AppLocalizations.of(context)
                                    ?.title_check_password_3 ??
                                'Password must be contain at least one digit number';
                          }
                          return null;
                        },
                      ),
                      15.verticalSpace,
                      CustomText(
                          message:
                              AppLocalizations.of(context)?.confirm_password ??
                                  'Confirm Password',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      10.verticalSpace,
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
                          hintText: AppLocalizations.of(context)
                                  ?.confirm_password_message ??
                              'Confirm your password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                      ?.title_check_confirm_password_1 ??
                                  'Confirm Password is required';
                            }
                            if (value != password.text) {
                              return AppLocalizations.of(context)
                                      ?.title_check_confirm_password_2 ??
                                  'Passwords do not match!';
                            }
                            return null;
                          }),
                      // const SizedBox(
                      //   height: 18.sp,
                      // ),
                      18.verticalSpace,
                      CustomButton(
                          fontSize: 18.sp,
                          height: 60,
                          width: double.infinity,
                          buttonName: AppLocalizations.of(context)?.register ??
                              'Register',
                          colorShadow: Colors.transparent,
                          backgroundColorButton: AppColors.primaryButton,
                          borderColor: Colors.white,
                          textColor: Colors.white,
                          function: () async {
                            if (_formKey.currentState!.validate()) {
                              _progressDialog.show();
                              try {
                                if (password.text == confirmPassword.text) {
                                  String check = await Authenticate()
                                      .registerUser(username.text,
                                          emailAddress.text, password.text);
                                  if (check == '' || check.isEmpty) {
                                    // ignore: use_build_context_synchronously
                                    await Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const OTPPage(),
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
                                    // ignore: use_build_context_synchronously
                                    showFlushBarNotification(
                                        context,
                                        AppLocalizations.of(context)
                                                ?.title_successfully ??
                                            'Successfully',
                                        AppLocalizations.of(context)
                                                ?.title_enter_otp ??
                                            "Please enter your OTP",
                                        3);
                                  } else {
                                    await _progressDialog.hide();
                                    // ignore: use_build_context_synchronously
                                    showFlushBarNotification(
                                        context,AppLocalizations.of(context)?.title_failed  ?? "Failed", check, 3);
                                  }
                                }
                              } catch (e) {
                                // ignore: avoid_print
                                print(e);
                              } finally {
                                await _progressDialog.hide();
                              }
                            } else {
                              showFlushBarNotification(context,AppLocalizations.of(context)?.title_invalid_form ?? "Invalid Form",
                                 AppLocalizations.of(context)?.title_complete_form?? "Please complete the form property", 3);
                            }
                          }),
                      10.verticalSpace,
                      Padding(
                        padding: EdgeInsets.only(right: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                                message: AppLocalizations.of(context)
                                        ?.login_account ??
                                    'Already have an account ? ',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryText),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => SignInPage())),
                              child: CustomText(
                                  message:
                                      AppLocalizations.of(context)?.login ??
                                          'Log In',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.importantText),
                            )
                          ],
                        ),
                      )
                    ]),
              ),
            )),
            // const SizedBox(
            //   height: 20,
            // ),
            20.verticalSpace,
          ],
        ),
      ),
    );
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

import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text_field.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/sign_in_page.dart';
import 'package:attendance_system_nodejs/services/authentication_services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool isCheckNewPassword = true;
  bool isCheckConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  RegExp upperCaseRegex = RegExp(r'[A-Z]');
  RegExp digitRegex = RegExp(r'[0-9]');
  late ProgressDialog _progressDialog;

  String description =
      'Your new password must be unique from those previously used';

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
                padding: EdgeInsets.only(left: 15.w, top: 15.h, right: 15.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          message: AppLocalizations.of(context)
                                  ?.create_new_password ??
                              "Create New Password",
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      //  SizedBox(
                      //   height: 10,
                      // ),
                      10.verticalSpace,
                      CustomText(
                          message: AppLocalizations.of(context)
                                  ?.sub_create_new_password ??
                              description,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryText),
                      //  SizedBox(
                      //   height: 20,
                      // ),
                      20.verticalSpace,
                      CustomText(
                          message: AppLocalizations.of(context)?.new_password ??
                              "New Password",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      //  SizedBox(
                      //   height: 10,
                      // ),
                      10.verticalSpace,
                      CustomTextField(
                        readOnly: false,
                        controller: password,
                        textInputType: TextInputType.visiblePassword,
                        obscureText: isCheckNewPassword,
                        prefixIcon: Icon(null),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isCheckNewPassword = !isCheckNewPassword;
                              });
                            },
                            icon: isCheckNewPassword
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off)),
                        hintText: "New Password",
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
                      //  SizedBox(
                      //   height: 15,
                      // ),
                      15.verticalSpace,
                      CustomText(
                          message:
                              AppLocalizations.of(context)?.confirm_password ??
                                  "Confirm Password",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      //  SizedBox(
                      //   height: 10,
                      // ),
                      10.verticalSpace,
                      CustomTextField(
                        readOnly: false,
                        controller: confirmPassword,
                        textInputType: TextInputType.visiblePassword,
                        obscureText: isCheckConfirmPassword,
                        prefixIcon: Icon(null),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isCheckConfirmPassword =
                                    !isCheckConfirmPassword;
                              });
                            },
                            icon: isCheckConfirmPassword
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off)),
                        hintText: "Confirm Password",
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
                        },
                      ),
                      //  SizedBox(
                      //   height: 15,
                      // ),
                      15.verticalSpace,
                      Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: CustomButton(
                          fontSize: 18.sp,
                          // height: 60,
                          // width: 400,
                          buttonName:
                              AppLocalizations.of(context)?.reset_password ??
                                  "Reset Password",
                          backgroundColorButton: AppColors.primaryButton,
                          colorShadow: Colors.transparent,
                          borderColor: Colors.white,
                          textColor: Colors.white,
                          function: () async {
                            if (_formKey.currentState!.validate()) {
                              if (password.text == confirmPassword.text ||
                                  password.text
                                      .contains(confirmPassword.text)) {
                                // _progressDialog.show();
                                String check = await Authenticate()
                                    .resetPassword(
                                        studentDataProvider
                                            .userData.studentEmail,
                                        password.text);
                                if (check == '') {
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          SignInPage(),
                                      transitionDuration:
                                          Duration(milliseconds: 1000),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        var curve = Curves.easeInOutCubic;
                                        var tween = Tween(
                                                begin: Offset(1.0, 0.0),
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
                                  // _progressDialog.hide();
                                  // ignore: use_build_context_synchronously
                                  showFlushBarNotification(
                                      context,
                                      AppLocalizations.of(context)
                                              ?.title_successfully ??
                                          "Successfully",
                                      AppLocalizations.of(context)
                                              ?.update_password_successfully ??
                                          "Updated password successfully",
                                      3);
                                } else {
                                  // await _progressDialog.hide();
                                  // ignore: use_build_context_synchronously
                                  showFlushBarNotification(
                                      context,
                                      AppLocalizations.of(context)
                                              ?.title_failed ??
                                          "Failed updating",
                                      check,
                                      3);
                                }
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            //  SizedBox(height: 20,),
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

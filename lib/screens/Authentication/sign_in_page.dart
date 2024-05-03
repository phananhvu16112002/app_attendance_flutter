import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text_field.dart';
import 'package:attendance_system_nodejs/common/bases/image_slider.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/forgot_password.dart';
import 'package:attendance_system_nodejs/screens/Authentication/register_page.dart';
import 'package:attendance_system_nodejs/screens/Authentication/upload_image.dart';
import 'package:attendance_system_nodejs/screens/Home/home_page/home_page.dart';
import 'package:attendance_system_nodejs/services/authentication_services/authentication.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isCheckPassword = true;
  late ProgressDialog _progressDialog;

  @override
  void initState() {
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
  }

  @override
  void dispose() {
    emailAddress.dispose();
    password.dispose();
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
          const ImageSlider(),
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: 15.h, left: 20.w, right: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      message:
                          AppLocalizations.of(context)?.title_login ?? 'Login',
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                    5.verticalSpace,
                    CustomText(
                      message: AppLocalizations.of(context)?.login_message ??
                          'Login to continue using the app',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),

                    // const SizedBox(
                    //   height: 20,
                    // ),
                    20.verticalSpace,
                    CustomText(
                      message: 'Email',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
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
                          "Enter your email",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        final RegExp tdtuEmailExp = RegExp(
                            r'^[0-9A-Z]+@(student\.)?tdtu\.edu\.vn$',
                            caseSensitive: false);
                        if (!tdtuEmailExp.hasMatch(value)) {
                          return 'Please check your valid email TDTU';
                        }
                        return null;
                      },
                    ),
                    15.verticalSpace,
                    CustomText(
                      message:
                          AppLocalizations.of(context)?.password ?? 'Password',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
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
                      hintText: AppLocalizations.of(context)?.password_field ??
                          "Enter your password",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                    ),
                    10.verticalSpace,
                    Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const ForgotPassword(),
                                  transitionDuration:
                                      const Duration(milliseconds: 300),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomText(
                                      message: AppLocalizations.of(context)
                                              ?.forgot_password ??
                                          'Forgot Password?',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.importantText),
                                ],
                              ),
                            ))),

                    20.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(right: 0, left: 0),
                      child: CustomButton(
                          fontSize: 18.sp,
                          // height: 60,
                          // width: 400,
                          buttonName:
                              AppLocalizations.of(context)?.login ?? 'Login',
                          colorShadow: Colors.transparent,
                          backgroundColorButton: AppColors.primaryButton,
                          borderColor: Colors.white,
                          textColor: Colors.white,
                          function: () async {
                            // SharedPreferences sharedPreferences =
                            //     await SharedPreferences.getInstance();
                            if (_formKey.currentState!.validate()) {
                              try {
                                _progressDialog.show();
                                String check = await Authenticate()
                                    .login(emailAddress.text, password.text);
                                if (check == '' || check.isEmpty) {
                                  var studentID =
                                      await SecureStorage() //520h0380
                                          .readSecureData('studentID');
                                  var studentEmail =
                                      await SecureStorage() //520h3080@student.tdtu.edu
                                          .readSecureData('studentEmail');
                                  var studentName = await SecureStorage()
                                      .readSecureData('studentName');
                                  var requiredImage = await SecureStorage()
                                      .readSecureData('requiredImage');
                                  // var requiredImage = sharedPreferences
                                  //     .getBool('requiredImage');
                                  studentDataProvider.setStudentID(studentID);
                                  studentDataProvider
                                      .setStudentEmail(studentEmail);
                                  studentDataProvider
                                      .setStudentName(studentName);

                                  // ignore: use_build_context_synchronously
                                  await Navigator.pushAndRemoveUntil(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          requiredImage == 'true'
                                              ? const UploadImage()
                                              : const HomePage(),
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
                                    message: "Processing Data...",
                                    duration: const Duration(seconds: 3),
                                  ).show(context);
                                } else {
                                  await _progressDialog.hide();
                                  // ignore: use_build_context_synchronously

                                  await Flushbar(
                                    title: "Failed",
                                    message: "$check",
                                    duration: const Duration(seconds: 3),
                                  ).show(context);
                                }
                              } catch (e) {
                                print(e);
                              } finally {
                                await _progressDialog.hide();
                              }
                            } else {
                              await _progressDialog.hide();
                              await Flushbar(
                                title: "Invalid Form",
                                message: "Please complete the form property",
                                duration: const Duration(seconds: 10),
                              ).show(context); //CustomFlushBar Note in Facebook
                            }
                          }),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    10.verticalSpace,
                    //Build third login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          message:
                              AppLocalizations.of(context)?.register_account ??
                                  "Don't you have an account ? ",
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const RegisterPage(),
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var curve = Curves.easeInOutCubic;
                                  var tween = Tween(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero)
                                      .chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);
                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: CustomText(
                            message: AppLocalizations.of(context)?.register ??
                                'Register',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.importantText,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  Container buildIcon(String path) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          border: Border.all(width: 1.w, color: AppColors.secondaryText)),
      child: Image.asset(
        path,
        height: 40.h,
        width: 40.w,
      ),
    );
  }
}

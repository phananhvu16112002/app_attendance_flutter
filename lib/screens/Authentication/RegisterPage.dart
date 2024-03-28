import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_nodejs/common/bases/CustomButton.dart';
import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/bases/CustomTextField.dart';
import 'package:attendance_system_nodejs/common/bases/ImageSlider.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/OTPPage.dart';
import 'package:attendance_system_nodejs/services/Authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

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
              padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                          message: 'Register',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      const SizedBox(
                        height: 5,
                      ),
                      const CustomText(
                          message: 'Enter your personal information',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryText),
                      const SizedBox(
                        height: 20,
                      ),
                      const CustomText(
                          message: 'Student ID',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        readOnly: false,
                        controller: username,
                        textInputType: TextInputType.text,
                        obscureText: false,
                        prefixIcon: const Icon(null),
                        suffixIcon:
                            const IconButton(onPressed: null, icon: Icon(null)),
                        hintText: 'Enter your student ID',
                        onChanged: (value) {
                          studentDataProvider.setStudentName(value);
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length > 50) {
                            return 'Please check studentID(must not 50 characters) ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const CustomText(
                          message: 'Email',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        readOnly: false,
                        controller: emailAddress,
                        textInputType: TextInputType.emailAddress,
                        obscureText: false,
                        prefixIcon: const Icon(null),
                        suffixIcon:
                            const IconButton(onPressed: null, icon: Icon(null)),
                        hintText: 'Enter your email',
                        onChanged: (value) {
                          studentDataProvider.setStudentEmail(value);
                        },
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
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const CustomText(
                        message: 'Password',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                        hintText: 'Enter your password',
                        onChanged: (value) {
                          studentDataProvider.setPassword(value);
                        },
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
                      const SizedBox(
                        height: 15,
                      ),
                      const CustomText(
                          message: 'Confirm Password',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      const SizedBox(
                        height: 10,
                      ),
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
                          hintText: 'Confirm your password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm Password is required';
                            }
                            if (value != password.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          fontSize: 20,
                          height: 60,
                          width: 400,
                          buttonName: 'Register',
                          colorShadow: AppColors.colorShadow,
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
                                        "Successfully",
                                        "Please enter your OTP",
                                        3);
                                  } else {
                                    await _progressDialog.hide();
                                    // ignore: use_build_context_synchronously
                                    showFlushBarNotification(
                                        context, "Failed", check, 3);
                                  }
                                }
                              } catch (e) {
                                // ignore: avoid_print
                                print(e);
                              } finally {
                                await _progressDialog.hide();
                              }
                            } else {
                              showFlushBarNotification(context, "Invalid Form",
                                  "Please complete the form property", 3);
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CustomText(
                                message: 'Already have an account ? ',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryText),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, "/Login"),
                              child: const CustomText(
                                  message: 'Log In',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.importantText),
                            )
                          ],
                        ),
                      )
                    ]),
              ),
            )),
            const SizedBox(height: 20,),
            
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

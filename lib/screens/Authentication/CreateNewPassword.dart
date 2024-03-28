import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_nodejs/common/bases/CustomButton.dart';
import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/bases/CustomTextField.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/SignInPage.dart';
import 'package:attendance_system_nodejs/services/Authenticate.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

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
                padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                          message: "Create New Password",
                          fontSize: 42,
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
                      const CustomText(
                          message: "New Password",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        readOnly: false,
                        controller: password,
                        textInputType: TextInputType.visiblePassword,
                        obscureText: isCheckNewPassword,
                        prefixIcon: const Icon(null),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isCheckNewPassword = !isCheckNewPassword;
                              });
                            },
                            icon: isCheckNewPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off)),
                        hintText: "New Password",
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
                          message: "Confirm Password",
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
                        hintText: "Confirm Password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Confirm password is required";
                          } else if (value != password.text) {
                            return 'Confirm password is not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: CustomButton(
                          fontSize: 20,
                          height: 60,
                          width: 400,
                          buttonName: "Reset Password",
                          backgroundColorButton: AppColors.primaryButton,
                          colorShadow: AppColors.colorShadow,
                          borderColor: Colors.white,
                          textColor: Colors.white,
                          function: () async {
                            if (_formKey.currentState!.validate()) {
                              if (password.text == confirmPassword.text ||
                                  password.text
                                      .contains(confirmPassword.text)) {
                                _progressDialog.show();
                                String check = await Authenticate()
                                    .resetPassword(
                                        studentDataProvider
                                            .userData.studentEmail,
                                        password.text);
                                if (check == '') {
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
                                  _progressDialog.hide();
                                  // ignore: use_build_context_synchronously
                                  showFlushBarNotification(
                                      context,
                                      "Successfully",
                                      "Updated password successfully",
                                      3);
                                } else {
                                  await _progressDialog.hide();
                                  // ignore: use_build_context_synchronously
                                  showFlushBarNotification(
                                      context, "Failed updating", check, 3);
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

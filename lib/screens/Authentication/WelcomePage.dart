import 'package:attendance_system_nodejs/common/bases/CustomButton.dart';
import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/bases/ImageSlider.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/screens/Authentication/RegisterPage.dart';
import 'package:attendance_system_nodejs/screens/Authentication/SignInPage.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String schoolName = 'Ton Duc Thang University';
  String descriptionSchool =
      'Lorem ipsum dolor sit amet consectetur adipisicing elit. Sequi sit maiores, perferendis suscipit veniam ratione fuga cumque incidunt quam deleniti vitae maxime totam omnis quidem quo consectetur ad? Veniam, harum? Lorem ipsum dolor sit amet consectetur adipisicing elit. Sequi sit maiores, perferendis suscipit veniam ratione fuga cumque incidunt quam deleniti vitae maxime totam omnis quidem quo consectetur ad? Veniam, harum? Lorem ipsum dolor sit amet consectetur adipisicing elit. Sequi sit maiores, perferendis suscipit veniam ratione fuga cumque incidunt quam deleniti vitae maxime totam omnis quidem quo consectetur ad? Veniam, harum?';
  @override
  void dispose() {
    print("Welcome Page dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const ImageSlider(),
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: 70,
                            height: 70,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          // Expanded(
                          //     child: CustomText(
                          //   message: schoolName,
                          //   fontSize: 40,
                          //   fontWeight: FontWeight.w800,
                          //   color: AppColors.primaryText,
                          // )),
                          Expanded(
                              child: customRichText(
                                  'TON ',
                                  'DUC ',
                                  'THANG ',
                                  'UNIVERISTY',
                                  FontWeight.w700,
                                  30,
                                  const Color(0xff0364A9),
                                  const Color(0xff0364A9),
                                  const Color(0xff0364A9),
                                  AppColors.primaryText))
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomText(
                          message: descriptionSchool,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: CustomButton(
                              fontSize: 20,
                              height: 60,
                              width: 400,
                              buttonName: 'Login',
                              colorShadow: AppColors.colorShadow,
                              backgroundColorButton: AppColors.primaryButton,
                              borderColor: Colors.transparent,
                              textColor: Colors.white,
                              function: () => Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          SignInPage(),
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
                                  ))),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: CustomButton(
                            fontSize: 20,
                            height: 60,
                            width: 400,
                            buttonName: 'Register',
                            colorShadow: Colors.transparent,
                            backgroundColorButton: Colors.white,
                            borderColor: AppColors.primaryButton,
                            textColor: AppColors.primaryButton,
                            function: () => Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        RegisterPage(),
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
                                )),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  RichText customRichText(
    String title,
    String title2,
    String title3,
    String title4,
    FontWeight fontWeightTitle,
    double fontSize,
    Color colorTextTitle,
    Color colorTextTitle2,
    Color colorTextTitle3,
    Color colorTextTitle4,
  ) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: title,
        style: TextStyle(
          fontWeight: fontWeightTitle,
          fontSize: fontSize,
          color: colorTextTitle,
        ),
      ),
      TextSpan(
        text: title2,
        style: TextStyle(
          fontWeight: fontWeightTitle,
          fontSize: fontSize,
          color: colorTextTitle2,
        ),
      ),
      TextSpan(
        text: title3,
        style: TextStyle(
          fontWeight: fontWeightTitle,
          fontSize: fontSize,
          color: colorTextTitle3,
        ),
      ),
      TextSpan(
        text: title4,
        style: TextStyle(
          fontWeight: fontWeightTitle,
          fontSize: fontSize,
          color: colorTextTitle4,
        ),
      ),
    ]));
  }
}

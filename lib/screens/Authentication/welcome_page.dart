import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/bases/image_slider.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/screens/Authentication/register_page.dart';
import 'package:attendance_system_nodejs/screens/Authentication/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String schoolName = 'Ton Duc Thang University';
  String descriptionSchool =
      "The automated attendance support system enhances efficiency and user experience by enabling fast, accurate attendance tracking for large classes. With real-time data synchronization and cloud storage, attendance records are always up-to-date and accessible. Mobile integration allows students to mark attendance easily, while lecturers can manage records securely from anywhere. Built with scalability in mind, the system uses modern technology to handle large datasets and traffic, making it reliable and adaptable for growing educational needs. The system's secure authentication protocols protect user data and ensure privacy. Its intuitive interface makes it easy for both students and lecturers to use without extensive training. Designed for long-term adaptability, the system can effortlessly integrate new features as educational demands evolve. By leveraging modern cloud infrastructure, the system ensures high availability and minimal downtime.";
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
                // height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 70.w,
                              height: 70.h,
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                                child: customRichText(
                                    'TON ',
                                    'DUC ',
                                    'THANG ',
                                    'UNIVERISTY',
                                    FontWeight.w700,
                                    30.sp,
                                    const Color(0xff0364A9),
                                    const Color(0xff0364A9),
                                    const Color(0xff0364A9),
                                    AppColors.primaryText))
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        CustomText(
                            message: descriptionSchool,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        20.verticalSpace,
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: CustomButton(
                                fontSize: 18.sp,
                                height: 60.h,
                                width: double.infinity,
                                buttonName:
                                    AppLocalizations.of(context)?.login ??
                                        'Login',
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
                              fontSize: 18.sp,
                              height: 60.h,
                              width: double.infinity,
                              buttonName:
                                  AppLocalizations.of(context)?.register ??
                                      'Register',
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
                        ),
                        SizedBox(
                          height: 100.h,
                        ),
                      ],
                    ),
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

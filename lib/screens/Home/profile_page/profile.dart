// import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
// import 'package:attendance_system_nodejs/screens/Authentication/sign_in_page.dart'
import 'package:attendance_system_nodejs/screens/Authentication/sign_in_page.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
// import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        //Colum Tong
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //AppBar
            Container(
              height: 170,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: AppColors.colorAppbar,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                child: Row(
                  children: [
                    Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Image.asset('assets/images/logo.png')),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                              message: 'Phan Anh Vu',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          const SizedBox(
                            height: 5,
                          ),
                          customRichText('StudentID: ', '520H0696',
                              FontWeight.w600, FontWeight.w500, Colors.white),
                          const SizedBox(
                            height: 5,
                          ),
                          customRichText('Class: ', '20H05031', FontWeight.w600,
                              FontWeight.w500, Colors.white)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: CustomText(
                  message: 'Setting and Privacy',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText),
            ),
            const SizedBox(
              height: 5,
            ),
            customOptions(
                context, 'assets/icons/changePassword.png', 'Password'),
            customOptions(
                context, 'assets/icons/notification.png', 'Sound Notification'),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: CustomText(
                  message: 'Display',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText),
            ),
            customOptions(context, 'assets/icons/modeTheme.png', 'Mode Theme'),
            customOptions(context, 'assets/icons/language.png', 'Language'),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: CustomText(
                  message: 'App',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText),
            ),
            customOptions(context, 'assets/icons/face_camera.png', 'View Face'),

            customOptions(context, 'assets/icons/information.png', 'About us'),
            InkWell(
                onTap: () async {
                  await SecureStorage().deleteSecureData('refreshToken');
                  await SecureStorage().deleteSecureData('accessToken');
                  await SecureStorage().deleteSecureData('_image1');
                  await SecureStorage().deleteSecureData('_image2');
                  await SecureStorage().deleteSecureData('_image3');
                  await Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => SignInPage()),
                      (route) => false);
                },
                child: customOptions(
                    context, 'assets/icons/signout.png', 'Sign out')),
          ],
        ),
      ),
    );
  }

  Padding customOptions(
    BuildContext context,
    String pathImage,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        color: Color.fromARGB(94, 237, 235, 235),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Image.asset(
                  pathImage,
                  width: 25,
                  height: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                    message: title,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryText)
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  RichText customRichText(
      String title,
      String message,
      FontWeight fontWeightTitle,
      FontWeight fontWeightMessage,
      Color colorText) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: title,
        style: TextStyle(
          fontWeight: fontWeightTitle,
          fontSize: 15,
          color: colorText,
        ),
      ),
      TextSpan(
        text: message,
        style: TextStyle(
          fontWeight: fontWeightMessage,
          fontSize: 15,
          color: colorText,
        ),
      ),
    ]));
  }
}

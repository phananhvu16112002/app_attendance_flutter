// import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/main.dart';
import 'package:attendance_system_nodejs/providers/language_provider.dart';
// import 'package:attendance_system_nodejs/screens/Authentication/sign_in_page.dart'
import 'package:attendance_system_nodejs/screens/Authentication/sign_in_page.dart';
import 'package:attendance_system_nodejs/screens/Home/profile_page/view_image_face/view_image_face.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
// import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String studentName = '';
  String studentID = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfor().then((value) {
      setState(() {
        studentName = value[0];
        studentID = value[1];
      });
    });
  }

  Future<List> getInfor() async {
    var temp1 = await SecureStorage().readSecureData('studentName');
    var temp2 = await SecureStorage().readSecureData('studentID');
    var tempArray = [];
    tempArray.add(temp1);
    tempArray.add(temp2);
    return tempArray;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void updateIsEngland(bool newValue) {
    setState(() {
      isEngland = newValue;
    });
  }

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
              // height: 150,
              padding: EdgeInsets.symmetric(vertical: 25.h),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: AppColors.colorAppbar,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.r),
                      bottomRight: Radius.circular(15.r))),
              child: Padding(
                padding: EdgeInsets.only(top: 0, left: 10.w, right: 10.w),
                child: Row(
                  children: [
                    Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Image.asset('assets/images/logo.png')),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, left: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              message: studentName,
                              fontSize: 23.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          5.verticalSpace,
                          customRichText('StudentID: ', studentName,
                              FontWeight.w600, FontWeight.w400, Colors.white),
                          const SizedBox(
                            height: 5,
                          ),
                          customRichText('Class: ', '20H05031', FontWeight.w600,
                              FontWeight.w400, Colors.white)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            20.verticalSpace,

            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: CustomText(
                  message: 'Setting and Privacy',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText),
            ),
            5.verticalSpace,
            customOptions(
                context, 'assets/icons/changePassword.png', 'Password'),
            customOptions(
                context, 'assets/icons/notification.png', 'Sound Notification'),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: CustomText(
                  message: 'Display',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText),
            ),
            customOptions(context, 'assets/icons/modeTheme.png', 'Mode Theme'),
            InkWell(
                onTap: () {
                  _showBottomSheet(context);
                },
                child: customOptions(
                    context,
                    'assets/icons/language.png',
                    AppLocalizations.of(context)?.title_profile_language ??
                        'Language')),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: CustomText(
                  message: 'App',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText),
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const ViewImageFacePage()));
                },
                child: customOptions(
                    context, 'assets/icons/face_camera.png', 'View Face')),

            customOptions(context, 'assets/icons/information.png', 'About us'),
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (builder) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('Sign out'),
                            content: const Text('Are you sure ?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () async {
                                    await SecureStorage()
                                        .deleteSecureData('refreshToken');
                                    await SecureStorage()
                                        .deleteSecureData('accessToken');
                                    await SecureStorage()
                                        .deleteSecureData('_image1');
                                    await SecureStorage()
                                        .deleteSecureData('_image2');
                                    await SecureStorage()
                                        .deleteSecureData('_image3');

                                    await Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                const SignInPage()),
                                        (route) => false);
                                  },
                                  child: const Text('OK'))
                            ],
                          ));
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
      padding: EdgeInsets.only(right: 8.w),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50.h,
        color: const Color.fromARGB(94, 237, 235, 235),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 20.w,
                ),
                Image.asset(
                  pathImage,
                  width: 25.w,
                  height: 25.h,
                ),
                SizedBox(
                  width: 10.w,
                ),
                CustomText(
                    message: title,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryText)
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: 13.sp,
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
          fontSize: 13.sp,
          color: colorText,
        ),
      ),
      TextSpan(
        text: message,
        style: TextStyle(
          fontWeight: fontWeightMessage,
          fontSize: 13.sp,
          color: colorText,
        ),
      ),
    ]));
  }

  // void _showBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     isDismissible: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
  //     ),
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (context, setState) {
  //         return Container(
  //           // height: 330,
  //           padding: EdgeInsets.symmetric(vertical: 5.h),
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Center(
  //                   child: CustomText(
  //                     message: 'Chọn ngôn ngữ',
  //                     fontSize: 20.sp,
  //                     fontWeight: FontWeight.w700,
  //                     color: AppColors.primaryButton,
  //                   ),
  //                 ),
  //                 10.verticalSpace,
  //                 vietnamOption(() {
  //                   setState(() {
  //                     isEngland = false;
  //                   });
  //                 }),
  //                 englandOption(() {
  //                   setState(() {
  //                     isEngland = true;
  //                   });
  //                 }),
  //                 const SizedBox(
  //                   height: 110,
  //                 ),
  //                 CustomButton(
  //                   buttonName: 'Xác nhận',
  //                   backgroundColorButton: AppColors.primaryButton,
  //                   borderColor: Colors.transparent,
  //                   textColor: Colors.white,
  //                   function: () {
  //                     Navigator.pop(context);
  //                   },
  //                   fontSize: 16.sp,
  //                   colorShadow: Colors.transparent,
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CustomText(
                      message: 'Chọn ngôn ngữ',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryButton,
                    ),
                  ),
                  10.verticalSpace,
                  vietnamOption(() {
                    setState(() {
                      isEngland = false;
                    });
                  }),
                  englandOption(() {
                    setState(() {
                      isEngland = true;
                    });
                  }),
                  const SizedBox(
                    height: 110,
                  ),
                  CustomButton(
                    buttonName: 'Xác nhận',
                    backgroundColorButton: AppColors.primaryButton,
                    borderColor: Colors.transparent,
                    textColor: Colors.white,
                    function: () {
                      Provider.of<LanguageProvider>(context, listen: false)
                          .toggleLanguage(isEngland);

                      Navigator.pop(context);
                    },
                    fontSize: 16.sp,
                    colorShadow: Colors.transparent,
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Padding englandOption(Function() onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: InkWell(
        onTap: onTap,
        child: Container(
          // height: 56.h,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.secondaryText)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/images/england.png'),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  CustomText(
                    message: 'Tiếng Anh',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryText,
                  ),
                ],
              ),
              Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: isEngland
                        ? AppColors.primaryButton
                        : AppColors.secondaryText,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isEngland
                          ? AppColors.primaryButton
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding vietnamOption(Function() onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: InkWell(
        onTap: onTap,
        child: Container(
          // height: 56,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.secondaryText)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset('assets/images/vietnam.png'),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  CustomText(
                    message: 'Tiếng Việt',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryText,
                  ),
                ],
              ),
              Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.w,
                    color: !isEngland
                        ? AppColors.primaryButton
                        : AppColors.secondaryText,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: !isEngland
                          ? AppColors.primaryButton
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

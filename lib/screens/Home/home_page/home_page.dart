import 'package:animations/animations.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/bottom_nav_model.dart';
import 'package:attendance_system_nodejs/screens/Authentication/welcome_page.dart';
import 'package:attendance_system_nodejs/screens/Home/floating_button_map/floating_button_map.dart';
import 'package:attendance_system_nodejs/screens/Home/home_page/components/home_page_body.dart';
import 'package:attendance_system_nodejs/screens/Home/notification_page/notification_page.dart';
import 'package:attendance_system_nodejs/screens/Home/profile_page/profile.dart';
import 'package:attendance_system_nodejs/screens/Home/report_page/report_page.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
// import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = SecureStorage();
  String? accessToken;
  String? refreshToken;
  int _bottomNavIndex = 0;
  bool activeFormAttendance = false;

  @override
  void dispose() {
    // controller.dispose(); controller QRCODE
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? loadToken = await storage.readSecureData('accessToken');
    String? refreshToken1 = await storage.readSecureData('refreshToken');
    if (loadToken.isEmpty ||
        refreshToken1.isEmpty ||
        loadToken.contains('No Data Found') ||
        refreshToken1.contains('No Data Found')) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    }
  }


  

  List<BottomNavModel> listBottomNav = [
    BottomNavModel(title: 'Home', svgPath: 'assets/icons/home.svg'),
    BottomNavModel(title: 'Report', svgPath: 'assets/icons/report.svg'),
    BottomNavModel(
        title: 'Notifications', svgPath: 'assets/icons/notification.svg'),
    BottomNavModel(title: 'Profile', svgPath: 'assets/icons/user.svg'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: AppColors.primaryButton,
          foregroundColor: Colors.white,
          elevation: 2,
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const FloatingButtonMap(),
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Icon(
            Icons.location_on_outlined,
            size: 26.sp,
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            // height: 74.h,
            itemCount: listBottomNav.length,
            tabBuilder: (index, isActive) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 25.w,
                      height: 25.h,
                      child: SvgPicture.asset(listBottomNav[index].svgPath,
                          width: 25.w,
                          height: 25.h,
                          color: isActive
                              ? AppColors.primaryButton
                              : AppColors.secondaryText)),
                  Text(
                    listBottomNav[index].title,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: isActive
                            ? AppColors.primaryButton
                            : AppColors.secondaryText),
                  )
                ],
              );
            },
            activeIndex: _bottomNavIndex,
            gapLocation: GapLocation.center,
            backgroundColor: Colors.white,
            onTap: onTapHandler),
        body: _buildBody());
  }

  void onTapHandler(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_bottomNavIndex) {
      case 0:
        return _buildPage(const HomePageBody());
      case 1:
        return _buildPage(const ReportPage());
      case 2:
        return _buildPage(const NotificationsPage());
      case 3:
        return _buildPage(const ProfilePage());
      default:
        return _buildPage(const HomePageBody());
    }
  }

  Widget _buildPage(Widget page) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: page,
    );
  }
}

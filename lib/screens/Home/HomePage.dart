import 'package:animations/animations.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/screens/Authentication/WelcomePage.dart';
import 'package:attendance_system_nodejs/screens/Home/FloatingButtonMap.dart';
import 'package:attendance_system_nodejs/screens/Home/components/HomePageBody.dart';
import 'package:attendance_system_nodejs/screens/Home/NotificationsPage.dart';
import 'package:attendance_system_nodejs/screens/Home/Profile.dart';
import 'package:attendance_system_nodejs/screens/Home/ReportPage.dart';
import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

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

  final List<IconData> _iconList = [
    Icons.home_outlined,
    Icons.mail_outline,
    Icons.notifications_none_outlined,
    Icons.person_2_outlined
  ];

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
          child: const Icon(
            Icons.location_on_outlined,
            size: 30,
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
            icons: _iconList,
            activeIndex: _bottomNavIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.verySmoothEdge,
            activeColor: AppColors.primaryButton,
            iconSize: 25,
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

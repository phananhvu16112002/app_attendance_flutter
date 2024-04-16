import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/student_classes.dart';
import 'package:attendance_system_nodejs/models/bottom_nav_model.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/class_room/class_room.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/detail_page/components/detail_page_body.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/notification_class/notification_class.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/report_class/report_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.classesStudent,
    // required this.studentClasses,
  });
  // final StudentClasses studentClasses;
  final ClassesStudent classesStudent;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _bottomNavIndex = 0;
  final List<IconData> _iconList = [
    Icons.newspaper,
    Icons.mail_outline,
    Icons.notifications_none_outlined,
    Icons.people
  ];
  // late StudentClasses studentClasses;
  late ClassesStudent classesStudent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classesStudent = widget.classesStudent;
    Future.delayed(Duration.zero, () {
      if (mounted) {
        var socketServerDataProvider =
            Provider.of<SocketServerProvider>(context, listen: false);
        socketServerDataProvider.connectToSocketServer(classesStudent.classID);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavModel> listBottomNav = [
      BottomNavModel(title: 'Home', svgPath: 'assets/icons/home.svg'),
      BottomNavModel(title: 'Report', svgPath: 'assets/icons/home.svg'),
      BottomNavModel(title: 'History', svgPath: 'assets/icons/home.svg'),
      BottomNavModel(title: 'Profile', svgPath: 'assets/icons/user.svg'),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            height: 65.h,
            itemCount: listBottomNav.length,
            tabBuilder: (index, isActive) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: SvgPicture.asset(listBottomNav[index].svgPath,
                          width: 24.w,
                          height: 24.h,
                          color: isActive
                              ? AppColors.primaryButton
                              : AppColors.secondaryText)),
                  Text(
                    listBottomNav[index].title,
                    style: TextStyle(
                        color: isActive
                            ? AppColors.primaryButton
                            : AppColors.secondaryText),
                  )
                ],
              );
            },
            activeIndex: _bottomNavIndex,
            gapLocation: GapLocation.none,
            backgroundColor: Colors.white,
            onTap: onTapHandler),
        // appBar: customAppbar(socketServerDataProvider),
        body: _buildBody());
  }

  Widget _buildBody() {
    switch (_bottomNavIndex) {
      case 0:
        return DetailPageBody(
          classesStudent: widget.classesStudent,
        );
      case 1:
        return const ReportClass();
      case 2:
        return const NotificationClass();
      case 3:
        return const Classroom();
      default:
        return DetailPageBody(
          classesStudent: widget.classesStudent,
        );
    }
  }

  void onTapHandler(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }
}

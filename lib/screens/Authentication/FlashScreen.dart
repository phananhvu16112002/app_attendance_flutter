import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocationService();
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        var studentDataProvider =
            Provider.of<StudentDataProvider>(context, listen: false);
        studentDataProvider.updateLocationData(
          studentDataProvider.userData.latitude,
          studentDataProvider.userData.longtitude,
          studentDataProvider.userData.location,
        );
      }
      //Should call api to get location in flash
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (builder) => WelcomePage()));
    });
  }

  Future<void> checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSettingsAlert();
    }
  }

  void showSettingsAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission'),
        content: const Text('Please grant permission to get your location.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Đóng hộp thoại
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
            },
            child: const Text(
              'Open Settings',
              style: TextStyle(color: AppColors.primaryButton),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            // CustomText(
            //     message: 'Loading...',
            //     fontSize: 30,
            //     fontWeight: FontWeight.w700,
            //     color: AppColors.primaryButton)
          ],
        ),
      ),
    );
  }
}

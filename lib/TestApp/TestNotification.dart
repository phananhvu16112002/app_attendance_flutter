import 'package:app_settings/app_settings.dart';
import 'package:attendance_system_nodejs/TestApp/TestNotification2.dart';
import 'package:attendance_system_nodejs/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class TestNotification extends StatefulWidget {
  const TestNotification({super.key});

  @override
  State<TestNotification> createState() => _TestNotificationState();
}

class _TestNotificationState extends State<TestNotification> {
  late final NotificationService notificationService;
  @override
  void initState() {
    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();
    checkNotificationPermission();
    super.initState();
  }

  void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((payload) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TestNotification2(payload: payload)));
      });
  void checkNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isDenied) {
      // Người dùng chưa cấp quyền, bạn có thể yêu cầu quyền ở đây
      requestNotificationPermission();
    } else if (status.isGranted) {
      // Người dùng đã cấp quyền
      print('Notification permission is granted.');
    }
  }

  void requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      // Người dùng đã cấp quyền
      print('Notification permission is granted.');
    } else if (status.isDenied) {
      // Người dùng từ chối cấp quyền
      print('Notification permission is denied.');
      // Hiển thị thông báo hoặc nút để chuyển đến cài đặt ứng dụng
      showSettingsAlert();
    }
  }

  void showSettingsAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notification Permission'),
        content: Text('Please grant permission to receive notifications.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng hộp thoại
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              AppSettings.openAppSettings(); // Mở cài đặt ứng dụng
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ElevatedButton(
                onPressed: () async {
                  await notificationService.showLocalNotification(
                      id: 0,
                      title: "Drink Water",
                      body: "Time to drink some water!",
                      payload: "You just took water! Huurray!");
                  print('Success');
                },
                child: const Text('Click'))));
  }
}

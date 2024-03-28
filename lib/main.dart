import 'package:attendance_system_nodejs/adapter/AttendanceFormAdapter.dart';
import 'package:attendance_system_nodejs/adapter/ClassesStudent.dart';
import 'package:attendance_system_nodejs/adapter/CourseAdapter.dart';
import 'package:attendance_system_nodejs/adapter/DataOfflineAdapter.dart';
import 'package:attendance_system_nodejs/adapter/StudentAdapter.dart';
import 'package:attendance_system_nodejs/adapter/StudentClassesAdapter.dart';
import 'package:attendance_system_nodejs/adapter/TeacherAdapter.dart';
import 'package:attendance_system_nodejs/adapter/ClassAdapter.dart';
import 'package:attendance_system_nodejs/models/AttendanceForm.dart';
import 'package:attendance_system_nodejs/models/ClassesStudent.dart';
import 'package:attendance_system_nodejs/models/DataOffline.dart';
import 'package:attendance_system_nodejs/models/StudentClasses.dart';
import 'package:attendance_system_nodejs/providers/attendanceDetail_data_provider.dart';
import 'package:attendance_system_nodejs/providers/attendanceFormForDetailPage_data_provider.dart';
import 'package:attendance_system_nodejs/providers/attendanceForm_data_provider.dart';
import 'package:attendance_system_nodejs/providers/classesStudent_data_provider.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/providers/studentClass_data_provider.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/CreateNewPassword.dart';
import 'package:attendance_system_nodejs/screens/Authentication/FlashScreen.dart';
import 'package:attendance_system_nodejs/screens/Authentication/ForgotPassword.dart';
import 'package:attendance_system_nodejs/screens/Authentication/ForgotPasswordOTPPage.dart';
import 'package:attendance_system_nodejs/screens/Authentication/OTPPage.dart';
import 'package:attendance_system_nodejs/screens/Authentication/RegisterPage.dart';
import 'package:attendance_system_nodejs/screens/Authentication/SignInPage.dart';
import 'package:attendance_system_nodejs/screens/Authentication/UploadImage.dart';
// import 'package:attendance_system_nodejs/screens/Authentication/SplashScreen.dart';
import 'package:attendance_system_nodejs/screens/Authentication/WelcomePage.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/ReportClass.dart';
// import 'package:attendance_system_nodejs/screens/DetailHome/ReportAttendance.dart';
// import 'package:attendance_system_nodejs/screens/Home/AfterAttendance.dart';
// import 'package:attendance_system_nodejs/screens/Home/AttendanceFormPage.dart';
import 'package:attendance_system_nodejs/screens/Home/DetailReport.dart';
import 'package:attendance_system_nodejs/screens/Home/HomePage.dart';
import 'package:attendance_system_nodejs/screens/Home/Profile.dart';
// import 'package:attendance_system_nodejs/TestApp/Test.dart';
// import 'package:attendance_system_nodejs/TestApp/TestAvatar.dart';
// import 'package:attendance_system_nodejs/TestApp/TestConnection.dart';
// import 'package:attendance_system_nodejs/TestApp/TestCustomLoading.dart';
// import 'package:attendance_system_nodejs/TestApp/TestTakeAttendance.dart';
import 'package:face_camera/face_camera.dart';
// import 'package:attendance_system_nodejs/screens/Home/ReportPage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize(); //Add this
  await Hive.initFlutter();
  Hive.registerAdapter(ClassAdapter());
  Hive.registerAdapter(TeacherAdapter());
  Hive.registerAdapter(CourseAdapter());
  Hive.registerAdapter(StudentClassesAdapter());
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(AttendanceFormAdapter());
  Hive.registerAdapter(DataOfflineAdatper());
  Hive.registerAdapter(ClassesStudentAdapter());

  await Hive.openBox<StudentClasses>('student_classes');
  await Hive.openBox<DataOffline>('DataOfflineBoxes');
  await Hive.openBox<AttendanceForm>('AttendanceFormBoxes');
  await Hive.openBox<ClassesStudent>('classes_student_box');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentDataProvider()),
        ChangeNotifierProvider(create: (_) => StudentClassesDataProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceDetailDataProvider()),
        ChangeNotifierProvider(create: (_) => SocketServerProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceFormDataProvider()),
        ChangeNotifierProvider(create: (_) => ClassesStudentProvider()),
        ChangeNotifierProvider(
            create: (_) => AttendanceFormDataForDetailPageProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.backgroundColor),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/Welcome': (context) => const WelcomePage(),
        '/Login': (context) => const SignInPage(),
        '/Register': (context) => const RegisterPage(),
        '/ForgotPassword': (context) => const ForgotPassword(),
        '/ForgotPasswordOTP': (context) => const ForgotPasswordOTPPage(),
        '/CreateNewPassword': (context) => const CreateNewPassword(),
        '/OTP': (context) => const OTPPage(),
        '/HomePage': (context) => const HomePage(),
        '/ProfilePage': (context) => const ProfilePage(),
        // '/DetailReport': (context) => const DetailReport(),
      },
      home: const FlashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

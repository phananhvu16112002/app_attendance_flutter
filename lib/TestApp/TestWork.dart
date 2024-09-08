import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workmanager/workmanager.dart';

class TestWork extends StatefulWidget {
  const TestWork({super.key});

  @override
  State<TestWork> createState() => _TestWorkState();
}

class _TestWorkState extends State<TestWork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
        child: Center(
            child: InkWell(
          onTap: () {
            Workmanager().registerOneOffTask(
                '1222222222232',
                 "sendLastLocation",
                initialDelay: Duration(seconds: 10),
                inputData: {
                  'formID': 'd88c237f-6ef0-45ec-a0e9-60a934304ec3',
                  "studentID": '520H0777',
                  "classID": '501044-3-1-1',
                },
                constraints: Constraints(networkType: NetworkType.connected)
                );
          },
          child: Container(
            width: 200.w,
            height: 100.h,
            color: Colors.white,
            child: Center(
              child: Text(
                'Test',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )),
      ),
    );
  }
}

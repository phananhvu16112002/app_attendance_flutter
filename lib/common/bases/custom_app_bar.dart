// import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget {
   CustomAppBar({super.key, required this.context, required this.address});

  final BuildContext context;
  final String address;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  String studentName = '';
  String studentID = '';

  @override
  void initState() {
    super.initState();
    getInfor();
  }

  void getInfor() async {
    studentName = await SecureStorage().readSecureData('studentName');
    studentID = await SecureStorage().readSecureData('studentID');
  }

  @override
  Widget build(BuildContext context) {
    // final studentDataProvider = Provider.of<StudentDataProvider>(context);

    return Container(
      // height: 320,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      width: MediaQuery.of(context).size.width,
      decoration:  BoxDecoration(
          color: AppColors.colorAppbar,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r))),
      child: Column(
        children: [
          Padding(
            padding:  EdgeInsets.only(left: 15.w, top: 25.h, right: 10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                         CustomText(
                            message: 'Hi, ',
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.thirdText),
                        CustomText(
                            message: studentName,
                            fontSize: 23.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ],
                    ),
                    Container(
                      height: 1,
                      color:  Color.fromARGB(106, 255, 255, 255),
                      width: 140,
                    ),
                     10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                             Icon(Icons.person_3_outlined,
                                size: 11, color: AppColors.thirdText),
                            CustomText(
                                message: '$studentID | ',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.thirdText),
                             CustomText(
                                message: 'Student',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.thirdText),
                          ],
                        ),
                      ],
                    ),
                     SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 290,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           Icon(Icons.location_on_outlined,
                              size: 11, color: Colors.white),
                          Expanded(
                            child: Text(
                              widget.address,
                              style:  TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                     SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                 Padding(
                  padding: EdgeInsets.only(top: 30, right: 5),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color:  Color.fromARGB(106, 255, 255, 255)),
           SizedBox(
            height: 5,
          ),
          EasyDateTimeLine(
            initialDate: DateTime.now(),
            onDateChange: (selectedDate) {
              //`selectedDate` the new date selected.
            },
            headerProps:  EasyHeaderProps(
                selectedDateFormat: SelectedDateFormat.fullDateMonthAsStrDY,
                selectedDateStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                showMonthPicker: false,
                monthPickerType: MonthPickerType.dropDown,
                monthStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                padding: EdgeInsets.only(top: 5, bottom: 15, left: 10)),
            dayProps:  EasyDayProps(
              dayStructure: DayStructure.dayStrDayNumMonth,
              width: 65,
              height: 85,
              borderColor: Color.fromARGB(61, 207, 204, 204),
              //activeDay
              activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  dayNumStyle: TextStyle(
                      color: AppColors.primaryButton,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  dayStrStyle: TextStyle(
                      color: AppColors.primaryButton,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                  monthStrStyle: TextStyle(
                      color: AppColors.primaryButton,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              //inactiveDay
              inactiveDayStyle: DayStyle(
                  dayNumStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  dayStrStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                  monthStrStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
              //TodayStyle
              todayStyle: DayStyle(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(78, 219, 217, 217),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  dayNumStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  dayStrStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                  monthStrStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ),
          ),
           SizedBox(
            height: 5,
          ),
          Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color:  Color.fromARGB(106, 255, 255, 255)),
        ],
      ),
    );
  }
}

import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCalendar extends StatelessWidget {
  const CustomCalendar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: null,
      headerProps: EasyHeaderProps(
          selectedDateFormat: SelectedDateFormat.fullDateMonthAsStrDY,
          selectedDateStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold),
          showMonthPicker: false,
          monthPickerType: MonthPickerType.dropDown,
          monthStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold),
          padding: EdgeInsets.only(top: 5.h, bottom: 15.h, left: 10.w)),
      dayProps: EasyDayProps(
        dayStructure: DayStructure.dayStrDayNumMonth,
        width: 60.w,
        height: 85.h,
        borderColor: Color.fromARGB(61, 207, 204, 204),
        //activeDay
        activeDayStyle: DayStyle(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            dayNumStyle: TextStyle(
                color: AppColors.primaryButton,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
            dayStrStyle: TextStyle(
                color: AppColors.primaryButton,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600),
            monthStrStyle: TextStyle(
                color: AppColors.primaryButton,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600)),
        //inactiveDay
        inactiveDayStyle: DayStyle(
            dayNumStyle: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
            dayStrStyle: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500),
            monthStrStyle: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400)),
        //TodayStyle
        todayStyle: DayStyle(
            decoration: BoxDecoration(
                color: Color.fromARGB(78, 219, 217, 217),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            dayNumStyle: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold),
            dayStrStyle: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600),
            monthStrStyle: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

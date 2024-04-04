import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class CustomCalendar extends StatelessWidget {
  const CustomCalendar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        //`selectedDate` the new date selected.
      },
      headerProps: const EasyHeaderProps(
          selectedDateFormat:
              SelectedDateFormat.fullDateMonthAsStrDY,
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
      dayProps: const EasyDayProps(
        dayStructure: DayStructure.dayStrDayNumMonth,
        width: 65,
        height: 85,
        borderColor: Color.fromARGB(61, 207, 204, 204),
        //activeDay
        activeDayStyle: DayStyle(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.all(Radius.circular(10))),
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
                borderRadius:
                    BorderRadius.all(Radius.circular(10))),
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
    );
  }
}
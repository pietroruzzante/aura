import 'package:aura/models/day.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/screens/Homepage.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class SevenDayCalendar extends StatelessWidget {
  Day day;

  SevenDayCalendar({super.key, required this.day});
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = getDateForValue(day.toInt());
    return Container(
        height: 150,
        width: 500,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: EasyInfiniteDateTimeLine(
            firstDate: DateTime.now().subtract(Duration(days: 3)),
            focusDate: selectedDate,
            lastDate: DateTime.now().add(Duration(days: 3)),
            timeLineProps: EasyTimeLineProps(
                separatorPadding: 1.0, margin: EdgeInsets.zero),
            dayProps: EasyDayProps(
              inactiveDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                    bottom: BorderSide(
                      width: 2,
                      color: Palette.blue,
                    ),
                  ),
                ),
              ),
              todayStyle: DayStyle(
                monthStrStyle: TextStyle(color: Palette.blue),
                dayNumStyle: TextStyle(
                    color: Palette.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                dayStrStyle: TextStyle(color: Palette.blue),
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                    bottom: BorderSide(
                      width: 2,
                      color: Palette.blue,
                    ),
                  ),
                ),
              ),
              activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                color: Palette.deepBlue,
                borderRadius: BorderRadius.circular(20),
              )),
            ),
            showTimelineHeader: false,
            onDateChange: (selectedDate) => day.setDay(
                selectedDate, DateTime.now().subtract(Duration(days: 4))),
          ),
        ));
  }
}

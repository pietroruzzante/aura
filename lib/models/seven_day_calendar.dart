import 'package:aura/models/day.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/screens/Homepage.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class SevenDayCalendar extends StatefulWidget {
  final Day day;

  const SevenDayCalendar({super.key, required this.day});

  @override
  State<SevenDayCalendar> createState() => _SevenDayCalendarState();
}

class _SevenDayCalendarState extends State<SevenDayCalendar> {
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = getDateForValue(widget.day.toInt());
    return SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: EasyInfiniteDateTimeLine(
            firstDate: DateTime.now().subtract(const Duration(days: 3)),
            focusDate: selectedDate,
            lastDate: DateTime.now().add(const Duration(days: 3)),
            timeLineProps: const EasyTimeLineProps(
                separatorPadding: 2.0, margin: EdgeInsets.zero),
            dayProps: EasyDayProps(
              inactiveDayStyle: DayStyle(
                monthStrStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w700),
                dayNumStyle: const TextStyle(
                    color: Palette.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                dayStrStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w700),
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(20),
                  border: const Border(
                    right: BorderSide(
                      width: 0.5,
                      color: Palette.blue,
                    ),
                    bottom: BorderSide(
                      width: 2,
                      color: Palette.blue,
                    ),
                  ),
                ),
              ),
              todayStyle: DayStyle(
                monthStrStyle: const TextStyle(color: Palette.deepBlue, fontWeight: FontWeight.w700),
                dayNumStyle: const TextStyle(
                    color: Palette.deepBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                dayStrStyle: const TextStyle(color: Palette.deepBlue, fontWeight: FontWeight.w700),
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(20),
                  border: const Border(
                    bottom: BorderSide(
                      width: 2,
                      color: Palette.blue,
                    ),
                  ),
                ),
              ),
              activeDayStyle: DayStyle(
                dayNumStyle: const TextStyle(color: Palette.white, fontWeight: FontWeight.w700, fontSize: 22),
                dayStrStyle: const TextStyle(color: Palette.white, fontWeight: FontWeight.w700, fontSize: 14),
                monthStrStyle:  const TextStyle(color: Palette.white, fontWeight: FontWeight.w700, fontSize: 14),
                  decoration: BoxDecoration(
                color: Palette.deepBlue,
                borderRadius: BorderRadius.circular(20),
              )),
            ),
            showTimelineHeader: false,
            onDateChange: (selectedDate) => widget.day.setDay(
                selectedDate, DateTime.now().subtract(const Duration(days: 4))),
          ),
        ));
  }
}


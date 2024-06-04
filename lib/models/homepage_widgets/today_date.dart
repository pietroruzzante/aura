import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayDate extends StatefulWidget {
  final dynamic day;

  TodayDate(
      {super.key,
      required this.day});

  @override
  State<TodayDate> createState() => _TodayDateState();
}

class _TodayDateState extends State<TodayDate> {
  @override
  Widget build(BuildContext context) {
    DateTime associatedDate = getDateForValue(widget.day.toInt());
    String formattedDate = DateFormat('dd/MM/yyyy').format(associatedDate);
    String dayOfWeek = DateFormat('EEEE', 'en_IT').format(associatedDate);

    return SizedBox(
        width: 450,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            '$dayOfWeek, $formattedDate',
            style: WorkSans.headlineSmall,
          ),
        ]));
  }
}

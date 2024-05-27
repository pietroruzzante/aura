import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayArrows extends StatelessWidget {
  final VoidCallback incrementDay;
  final VoidCallback decrementDay;
  final day;

  DayArrows(
      {required this.incrementDay,
      required this.decrementDay,
      required this.day});

  @override
  Widget build(BuildContext context) {
    DateTime associatedDate = getDateForValue(day.toInt());
    String formattedDate = DateFormat('dd/MM/yyyy').format(associatedDate);
    String dayOfWeek = DateFormat('EEEE', 'en_IT').format(associatedDate);

    return Container(
        width: 450,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          /*IconButton(onPressed: decrementDay,icon: Icon(Icons.arrow_back_ios_new,size: 30,
          color: day.toInt() == 0 ? Palette.transparent : Palette.white,)),*/
          Text(
            '$dayOfWeek, $formattedDate',
            style: WorkSans.titleSmall.copyWith(color: Palette.white),
          ),
          /*IconButton(onPressed: incrementDay,icon: Icon(Icons.arrow_forward_ios,size: 30,
          color: day.toInt() == 6 ? Palette.transparent : Palette.white)),*/
        ]));
  }
}

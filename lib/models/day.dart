import 'package:flutter/material.dart';

class Day extends ChangeNotifier{
int day = 3;

    void decrementDay() {
      if (day > 0) {
          day--;
      print('day:$day');
      notifyListeners();
      }
    }

    void incrementDay() {
      if (day < 6) {
        day++;
      print('day:$day');
      notifyListeners();
      }
    }

    void setDay(DateTime selectedDateTime, DateTime firstDate) {
        final difference = selectedDateTime.difference(firstDate).inDays;
        day = difference;
        notifyListeners();
    }


  // Definizione degli operatori di confronto
  bool operator <(int other) => day < other;
  bool operator <=(int other) => day <= other;
  bool operator >(int other) => day > other;
  bool operator >=(int other) => day >= other;

  int toInt() {
    return day;
  }

  double toDouble() {
    double dayDouble = day.toDouble();
    return dayDouble;
  }
}



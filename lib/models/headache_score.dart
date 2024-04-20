import 'package:flutter/material.dart';

class HeadacheScore extends ChangeNotifier {
  int score = 0;

  int calculateScore(int stressScore, int weatherScore){
    int score = stressScore + weatherScore;
    notifyListeners();
    return score;
  }
}
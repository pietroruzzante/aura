import 'package:flutter/material.dart';

class HeadacheScore extends ChangeNotifier {
  double score = 0;

  double calculateScore(double stressScore, double weatherScore){
    score = stressScore + weatherScore;
    notifyListeners();
    return score;
  }
}
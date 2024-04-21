import 'package:flutter/material.dart';

class HeadacheScore extends ChangeNotifier {
  List<double> scores = [0, 0, 0, 0, 0, 0, 0];

  double getScore(int day){
    final stressScore = getStress();
    final weatherScore = getWeather();
    this.refreshScore(stressScore, weatherScore);
    return scores[day];
  }//getScore

  void refreshScore(List<double> stressScore, List<double> weatherScore){
    for (int i=0; i<6;i++){
      scores[i] = stressScore[i] + weatherScore[i];
    }
    notifyListeners();
  }//refreshScore
}





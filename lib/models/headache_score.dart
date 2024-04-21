import 'package:flutter/material.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_algo/ml_algo.dart';


class HeadacheScore extends ChangeNotifier {
  List<double> scores = [0, 0, 0, 0, 0, 0, 0];

  double getScore(int day) {
    return scores[day];
  } //getScore

  void refreshScore(List<double> stressScore, List<double> weatherScore) {
    final stressScore = getStress();
    final weatherScore = getWeather();
    for (int i = 0; i < 6; i++) {
      scores[i] = stressScore[i] + weatherScore[i];
    }
    notifyListeners();
  } //refreshScore

  List<double> getStress(){
    
    final featureNames = ["hours_of_sleep", "heart_rate"];
    final data = DataFrame([
      featureNames,
      [1.0, 200.0],
      [1.0, 200.0]
    ]); //Here we need data request from Impact and from database
    final classifier = DecisionTreeClassifier.fromJson('assets/classifier_model/stress_model.json');
    final prediction = classifier.predict(data).toMatrix().asFlattenedList;

    return prediction;
  } //getStress

  List<double> getWeather() {
    final pressure = [
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0
    ]; //Here we need data request from weather API with barometric pressure value and from database
    final weatherScore = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

    for (int i = 0; i < 6; i++) {
      final tmp = pressure[i];
      if (tmp >= 1013.0) {
        weatherScore[i] = 0.0;
      } else if ((tmp < 1013) & (tmp <= 1007)) {
        weatherScore[i] = 1.0;
      } else if ((tmp < 1007) & (tmp <= 1005)) {
        weatherScore[i] = 2.0;
      } else if ((tmp < 1005) & (tmp <= 1003)) {
        weatherScore[i] = 3.0;
      } else if (tmp < 1003) {
        weatherScore[i] = 4.0;
      }
    }

    return weatherScore;
  } //getWeather

}

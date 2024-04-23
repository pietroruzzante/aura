import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_algo/ml_algo.dart';


class HeadacheScore extends ChangeNotifier {
  List<double> scores = [0, 0, 0, 0, 0, 0, 0];

  double getScore(int day) {
    refreshScore();
    return scores[day];
  } //getScore

  void refreshScore() async{
    final stressScore = await getStress();
    final weatherScore =  await getWeather();
    for (int i = 0; i < 6; i++) {
      scores[i] = stressScore[i] + weatherScore[i];
    }
    notifyListeners();
  } //refreshScore

  Future<List<double>> getStress() async{
    
    final featureNames = ["hours_of_sleep", "heart_rate"];
    await Future.delayed(const Duration(seconds: 2));//Provvisorio fino a accesso server
    final data = DataFrame([
      featureNames,
      [1.0, 200.0],
      [1.0, 200.0],
      [1.0, 200.0],
      [1.0, 150.0],
      [1.0, 200.0],
      [1.0, 200.0],
      [1.0, 200.0]
    ]); //Here we need data request from Impact and from database
    final file = File('stress_model.json');
    final json = await file.readAsString();
    final classifier = DecisionTreeClassifier.fromJson(json);
    final prediction = classifier.predict(data).toMatrix().asFlattenedList;
    notifyListeners();
    return prediction;
  } //getStress

  Future<List<double>> getWeather() async{
    await Future.delayed(const Duration(seconds: 2)); //Provvisorio fino a accesso server
    final pressure = [
      0.0,
      0.0,
      0.0,
      1002.0,
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
    notifyListeners();
    return weatherScore;
  } //getWeather

}

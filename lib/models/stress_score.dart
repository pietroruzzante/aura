import 'package:flutter/material.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_algo/ml_algo.dart';
import 'dart:io';

class StressScore extends ChangeNotifier {

List<double> scores = [0, 0, 0, 0, 0, 0, 0];

Future<List<double>> getStress(DataFrame data) async{

  const path = 'assets/classifier_model/stress_model.json';
  final file = File(path);
  final encodedModel = await file.readAsString();
  final classifier =  DecisionTreeClassifier.fromJson(encodedModel);

  final featureNames = ["hours_of_sleep", "heart_rate"];
  final data = DataFrame([featureNames, [1.0, 200.0], [1.0, 200.0]]); //Here we need data request from Fitbit device for sleep hours and HR
  final prediction = classifier.predict(data).toMatrix().asFlattenedList;

return prediction;
}//getStress




}
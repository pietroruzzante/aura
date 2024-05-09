import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:flutter/services.dart';

class HeadacheScore {
  final List<double> _scores = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

  double operator [](int index) => _scores[index];

  double getScore(int day) {
    refreshScore();
    return _scores[day];
  } //getScore

  Future<List<double>> refreshScore() async {
    final stressScore = await getStress();
    final weatherScore = await getWeather();
    for (int i = 0; i < 6; i++) {
      _scores[i] = stressScore[i] + weatherScore[i];
    }
    return _scores;
  } //refreshScore

  Future<List<double>> getStress() async {
    final featureNames = ["hours_of_sleep", "heart_rate"];
    //await Future.delayed(const Duration(seconds: 2));//Provvisorio fino a accesso server
    final data = DataFrame([
      featureNames,
      [8.0, 80.0],
      [7.0, 110.0],
      [6.0, 70.0],
      [6.0, 150.0],
      [6.0, 200.0],
      [4.0, 100.0],
      [1.0, 200.0]
    ]); //Here we need data request from Impact and from database
    final json = await rootBundle.loadString('assets/stress_model.json');
    final classifier = DecisionTreeClassifier.fromJson(json);
    final prediction = classifier.predict(data).toMatrix().asFlattenedList;
    return prediction;
  } //getStress

  Future<List<double>> getWeather() async {
    await Future.delayed(
        const Duration(seconds: 2)); //Provvisorio fino a accesso server
    final pressure = [
      1015.0,
      1013.0,
      1011.0,
      1010.0,
      1009.0,
      1005.0,
      1002.0,
    ]; //Here we need data request from weather API with barometric pressure value and from database
    final weatherScore = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

    for (int i = 0; i < 6; i++) {
      final tmp = pressure[i];
      if (tmp >= 1013.0) {
        weatherScore[i] = 0.0;
      } else if ((tmp < 1013) & (tmp >= 1007)) {
        weatherScore[i] = 1.0;
      } else if ((tmp < 1007) & (tmp >= 1005)) {
        weatherScore[i] = 2.0;
      } else if ((tmp < 1005) & (tmp >= 1003)) {
        weatherScore[i] = 3.0;
      } else if (tmp < 1003) {
        weatherScore[i] = 4.0;
      }
    }
    return weatherScore;
  } //getWeather
}

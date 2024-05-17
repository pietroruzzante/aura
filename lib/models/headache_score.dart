import 'package:aura/models/database.dart';
import 'package:aura/services/openWeather.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:flutter/services.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sembast/sembast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class HeadacheScore {
  final List<double> _scores = List<double>.filled(7, 0.0);

  double operator [](int index) => _scores[index];

  Future<HeadacheScore> refreshScore() async {
    final stressScore = await getStress();
    final weatherScore = await getWeather();
    print('weatherScore:${weatherScore}');
    print('stressScore:${stressScore}');

    DateTime today = DateTime.now();
    print('today: $today');
    DateTime yesterday = today.subtract(Duration(days: 1));

    var dir = await getApplicationDocumentsDirectory();
    DatabaseFactory dbFactory = databaseFactoryIo;
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'my_database.db');
    Database db = await dbFactory.openDatabase(dbPath);
    print('database: $db');
    

    for (int i = 3; i < 6; i++) {
      _scores[i] = stressScore[i] + weatherScore[i];
    }
    /*
    if (db.dateEquals(db.getRecord('day3')[0],today)){
      print('db day 3: ${db['day3'][0]}');
      print('caso1');
      for (int i = 0; i < 2; i++) {
         _scores[i] = db['day$i'][1];
      }
    } else if (db.dateEquals(db['day3'][0],yesterday)){
      print('caso2');
      db.updateDatabase(today, _scores[3]);
        for (int i = 0; i < 2; i++) {
        _scores[i] = db['day$i'][1];
        }
    } else {
        print('caso3');
        db.resetDatabase(today, _scores[3]);
         for (int i = 0; i < 2; i++) {
          _scores[i] = db['day$i'][1];
         } 
    }
    */
    print('final scores: $_scores');
    return this;
  } //refreshScore

  Future<List<double>> getStress() async {
    final featureNames = ["hours_of_sleep", "heart_rate"];
    //await Future.delayed(const Duration(seconds: 2));//Provvisorio fino a accesso server
    final data = DataFrame([
      featureNames,
      [0.0, 0.0],
      [0.0, 0.0],
      [0.0, 0.0],
      [6.0, 90.0],
      [0.0, 0.0],
      [0.0, 0.0],
      [0.0, 0.0]
    ]); //Here we need data request from Impact and from database
    final json = await rootBundle.loadString('assets/stress_model.json');
    final classifier = DecisionTreeClassifier.fromJson(json);
    final prediction = classifier.predict(data).toMatrix().asFlattenedList;
    return prediction;
  } //getStress

  Future<List<double>> getWeather() async {
    final pressures = List<double>.filled(7, 0.0, growable: true);
    final dates = unixDates();
    print('dates: $dates');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //int zip = 35137;

    int zip = int.parse(prefs.getString('address')!);

    final coordinates = await Openweather().getCoordinates(zip);
    final decodedResponse = await Openweather().getData(coordinates);
    double pressure;
    
    for(int i=3; i<7; i++){
      final timestamp = dates[i];
      String selected = 'forecast';
      if(i==3){selected = 'current';}

      pressure = getPressureFromTimestamp(timestamp, decodedResponse, selected);
      print('i=$i: pressure value for timestamp $timestamp: pressure=$pressure hPa');
      pressures[i] = pressure;

    }

    print('pressures:$pressures');
    final weatherScore = List<double>.filled(7, 0.0);

    for (int i = 3; i < 7; i++) {
      final tmp = pressures[i];
      if (tmp >= 1011.0) {
        weatherScore[i] = 1.0;
      } else if ((tmp < 1011) & (tmp >= 1009)) {
        weatherScore[i] = 3.0;
      } else if ((tmp < 1009) & (tmp >= 1007)) {
        weatherScore[i] = 2.0;
      } else if ((tmp < 1007) & (tmp >= 1005)) {
        weatherScore[i] = 3.0;
      } else if ((tmp < 1005) & (tmp >= 1003)) {
        weatherScore[i] = 4.0;
      } else if ((tmp < 1003) & (tmp >= 1001)) {
        weatherScore[i] = 2.0;
      } else if ((tmp < 1001) & (tmp >= 997)){
        weatherScore[i] = 1.0;
      } else if (tmp < 997) {
        weatherScore[i] = 0.0;
      }
    }
    return weatherScore;
  } //getWeather
}


double getPressureFromTimestamp(int timestamp, Map<String, dynamic> decodedResponse, String selected) {
  double pressure = 0.0;

  if (selected == 'current') {
    if (decodedResponse['current'] != null && decodedResponse['current']['pressure_mb'] != null) {
      pressure = decodedResponse['current']['pressure_mb'];
      print('current timestamp found');
    } else {
      print("Error: 'current' or 'pressure_mb' is null in decodedResponse");
    }
  } else {
    if (decodedResponse['forecast'] != null && decodedResponse['forecast']['forecastday'] != null) {
      for (var forecastday in decodedResponse['forecast']['forecastday']) {
        if (forecastday['hour'] != null) {
          for (var value in forecastday['hour']) {
            final forecastTimestamp = value['time_epoch'];
            if (forecastTimestamp == timestamp) {
              if (value['pressure_mb'] != null) {
                pressure = value['pressure_mb'].toDouble();
                print('timestamp $timestamp found');
              } else {
                print("Error: 'pressure_mb' is null for timestamp: $timestamp");
              }
              break;
            }
          }
        } else {
          print("Error: 'hour' is null in 'forecastday'");
        }
      }
    } else {
      print("Error: 'forecast' or 'forecastday' is null in decodedResponse");
    }
  }
  return pressure;
}

 

List<int> unixDates(){
  List<DateTime> dates = List<DateTime>.filled(7, DateTime.now());

  for (int i = 0; i < 7; i++) {
    dates[i] = DateTime.now().subtract(Duration(days: 3)).add(Duration(days: i));
  }
  List<int> unixTimestamps = [];
  for (int i = 0; i < dates.length; i++) {
    DateTime noonDate = DateTime(dates[i].year, dates[i].month, dates[i].day, 12, 0, 0);
    int unixTimestamp = noonDate.millisecondsSinceEpoch ~/ 1000;
    unixTimestamps.add(unixTimestamp);
  }
  return unixTimestamps;
}



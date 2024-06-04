import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Impact {
  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  //static String username = 'qWgEn2F4fj';
  //static String password = '12345678!';

  static String patientUsername = 'Jpefaq6m58';

  //This method allows to check if the IMPACT backend is up
  Future<bool> isImpactUp() async {
    //Create the request
    final url = Impact.baseUrl + Impact.pingEndpoint;

    //Get the response
    //print('Calling: $url');
    final response = await http.get(Uri.parse(url));

    //Just return if the status code is OK
    return response.statusCode == 200;
  } //_isImpactUp

  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  Future<int> getAndStoreTokens(String username, String password) async {
    //Create the request
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': username, 'password': password};

    //Get the response
    //print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If response is OK, decode it and store the tokens. Otherwise do nothing.
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', decodedResponse['access']);
      await prefs.setString('refresh', decodedResponse['refresh']);
    }

    //Return the status code
    return response.statusCode;
  } //_getAndStoreTokens

  //This method allows to refrsh the stored JWT in SharedPreferences
  Future<int> refreshTokens() async {
    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString('refresh');
    if (refresh != null) {
      final body = {'refresh': refresh};

      //Get the response
      //print('Calling: $url');
      final response = await http.post(Uri.parse(url), body: body);

      //If the response is OK, set the tokens in SharedPreferences to the new values
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access', decodedResponse['access']);
        await prefs.setString('refresh', decodedResponse['refresh']);
      } //if

      //Just return the status code
      return response.statusCode;
    }
    return 401;
  } //_refreshTokens

  //This method checks if the saved token is still valid
  Future<bool> checkSavedToken({bool refresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(refresh ? 'refresh' : 'access');

    //Check if there is a token
    if (token == null) {
      return false;
    }
    try {
      return Impact.checkToken(token);
    } catch (_) {
      return false;
    }
  }

  static bool checkToken(String token) {
    //Check if the token is expired
    if (JwtDecoder.isExpired(token)) {
      return false;
    }
    return true;
  } //checkToken

  //This method prepares the Bearer header for the calls
  Future<Map<String, String>> getBearer() async {
    if (!await checkSavedToken()) {
      await refreshTokens();
    }
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');

    return {'Authorization': 'Bearer $token'};
  }
  
  Future<List<double>> getSleepHR() async {
    var header = await getBearer();
    var day = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days:1))); // set the day !!!! C'è un problema inserendo un il giorno DateTime.now().subtract(Duration(days:1))
    final urlSleep =
        '${Impact.baseUrl}data/v1/sleep/patients/$patientUsername/day/$day/';
    final urlRestHR =
        '${Impact.baseUrl}data/v1/resting_heart_rate/patients/$patientUsername/day/$day/';
    //print('urlSleep:$urlSleep');
    //print('urlRestHR:$urlRestHR');
    List<double> data = [];

    try{
    var r = await http.get(
      Uri.parse(urlSleep),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    final Map<String, dynamic> jsonData = jsonDecode(r.body);
    double duration;
        final dataContent = jsonData['data'];

        if (dataContent == null || dataContent.isEmpty) {
          duration = 0.0;
        } else if (dataContent['data'] is List) {
          if (dataContent['data'].isNotEmpty) {
            final sleepData = dataContent['data'][0];
            duration = sleepData['duration'] ?? 0.0;
          } else {
            duration = 0.0;
          }
        } else if (dataContent['data'] is Map) {
          duration = dataContent['data']['duration'] ?? 0.0;
        } else {
          duration = 0.0;
        }
    // final Map<String, dynamic> sleepData = jsonDecode(r.body);
    // final duration = sleepData['data']['data'][0]['duration'];

    double durationInHours = duration / 3600000;
    data.add(durationInHours);

    } catch (e){
      print('Error: $e');
    }

    try{
    var j = await http.get(  
      Uri.parse(urlRestHR),
      headers: header,
    );
    if (j.statusCode != 200) return [];

    final Map<String, dynamic> restHRData = jsonDecode(j.body);
    double restHR = restHRData['data']['data']['value'];
    data.add(restHR.toDouble());

    //print('datalist:$data');

    } catch(e){
      print('Error: $e');
    }

    return data;
  }

  Future<double> getTodaySleep() async {
    final todayData = await getSleepHR();
    final todaySleep = todayData[0];
    return todaySleep;
  }

  Future<String> getLastExerciseDate() async{

  String lastDate = 'Not available data';

  var header = await getBearer();
    var start_date = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days:4)));
    var end_date = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days:1)));
    final urlExercise =
        '${Impact.baseUrl}data/v1/exercise/patients/$patientUsername/daterange/start_date/$start_date/end_date/$end_date/';

    //print('urlExercise:$urlExercise');

    var r = await http.get(
      Uri.parse(urlExercise),
      headers: header,
    );

    if (r.statusCode != 200) return 'Not available data';

    final Map<String, dynamic> exerciseData = jsonDecode(r.body);
    final dataForEachDate = exerciseData['data'];
    for (var entry in dataForEachDate){
      if (entry['data'].isNotEmpty){
        lastDate = entry['date'];
      }
    }
    return lastDate;

  }

  Future<List<int>> calculateHRV()async{

   var header = await getBearer();
    var day = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days:1))); 
    final urlHeart =
        '${Impact.baseUrl}data/v1/heart_rate/patients/$patientUsername/day/$day/';

    print('Url Heart: $urlHeart');
    List<double> data = [];

    var r = await http.get(
      Uri.parse(urlHeart),
      headers: header,
    );
    print(r.statusCode);
    if (r.statusCode != 200) return [0, 0];

    final jsonData = jsonDecode(r.body);
    final List<dynamic> HRdata = jsonData['data']['data'];

    final heartRateData = HRdata.map<Map<String, dynamic>>((item) => {
      'value': item['value'],
    }).toList();

    //print('heart rate data: $heartRateData');

    if (heartRateData.length < 2) {
      return [0, 0];
    }
  

    List<int> rrIntervals = [];
    for (int i = 1; i < heartRateData.length; i++) {
    int bpm = heartRateData[i]['value'];
    int rrInterval = (60000 / bpm).round();
    rrIntervals.add(rrInterval);
    }

    if (rrIntervals.isEmpty) {
      return [0, 0];
    }

    final sdnn = calculateSDNN(rrIntervals);
    final rmssd = calculateRMSSD(rrIntervals);

    return [sdnn, rmssd];
}
} //Impact

int calculateSDNN(List<int> rrIntervals){
  double meanRR = rrIntervals.reduce((a, b) => a + b) / rrIntervals.length;
    double summed = 0.0;
    for (int interval in rrIntervals){
      summed += pow(interval - meanRR,2);
    }
    final sdnn = sqrt(summed/(rrIntervals.length - 1)).round();
    print('sdnn: $sdnn');
    return sdnn;
}

int calculateRMSSD(List<int> rrIntervals) {
  List<int> successiveDifferences = [];
  for (int i = 0; i < rrIntervals.length - 1; i++) {
    successiveDifferences.add(rrIntervals[i + 1] - rrIntervals[i]);
  }
  List<int> squaredDifferences = successiveDifferences.map((diff) => pow(diff, 2).toInt()).toList();
  double meanSquaredDifferences = squaredDifferences.reduce((a, b) => a + b) / squaredDifferences.length;
  int rmssd = sqrt(meanSquaredDifferences).toInt();
  print('rmssd: $rmssd');
  return rmssd;
}
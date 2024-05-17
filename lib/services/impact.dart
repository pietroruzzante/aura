import 'dart:convert';
import 'package:aura/models/heart_rate.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Impact {
  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  static String username = 'qWgEn2F4fj';
  static String password = '12345678!';

  static String patientUsername = 'Jpefaq6m58';

  //This method allows to check if the IMPACT backend is up
  Future<bool> isImpactUp() async {
    //Create the request
    final url = Impact.baseUrl + Impact.pingEndpoint;

    //Get the response
    print('Calling: $url');
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
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If response is OK, decode it and store the tokens. Otherwise do nothing.
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    }

    //Return the status code
    return response.statusCode;
  } //_getAndStoreTokens

  //This method allows to refrsh the stored JWT in SharedPreferences
  Future<int> refreshTokens() async {
    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    if (refresh != null) {
      final body = {'refresh': refresh};

      //Get the response
      print('Calling: $url');
      final response = await http.post(Uri.parse(url), body: body);

      //If the response is OK, set the tokens in SharedPreferences to the new values
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final sp = await SharedPreferences.getInstance();
        await sp.setString('access', decodedResponse['access']);
        await sp.setString('refresh', decodedResponse['refresh']);
      } //if

      //Just return the status code
      return response.statusCode;
    }
    return 401;
  } //_refreshTokens

  //This method checks if the saved token is still valid
  Future<bool> checkSavedToken({bool refresh = false}) async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString(refresh ? 'refresh' : 'access');

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
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('access');

    return {'Authorization': 'Bearer $token'};
  }
  
  Future<List<double>> getSleepHR() async {
    var header = await getBearer();
    var day = DateFormat('yyyy-MM-dd')
        .format(DateTime(2024, 4, 10)); // set the day !!!!
    final urlSleep =
        '${Impact.baseUrl}data/v1/sleep/patients/$patientUsername/day/$day/';
    final urlRestHR =
        '${Impact.baseUrl}data/v1/resting_heart_rate/patients/$patientUsername/day/$day/';
    print('urlSleep:$urlSleep');
    print('urlRestHR:$urlRestHR');

    var r = await http.get(
      Uri.parse(urlSleep),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    final Map<String, dynamic> sleepData = jsonDecode(r.body);
    print('Sleep Data: $sleepData');
    double duration = sleepData['data']['data']['duration'];
    print(duration);
    double durationInHours = duration / 3600000;
    List<double> data = [durationInHours];

    var j = await http.get(  
      Uri.parse(urlRestHR),
      headers: header,
    );
    if (j.statusCode != 200) return [];

    final Map<String, dynamic> restHRData = jsonDecode(j.body);
    double restHR = restHRData['data']['data']['value'];
    data.add(restHR.toDouble());

    print('datalist:$data');

    return data;
  }
} //Impact


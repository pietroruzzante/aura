import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Openweather{
  static const APIkey = '9eb79248952ff7bdd77ab6c7ea84ee2f';
  static const OpenWeatherUrl = 'http://api.openweathermap.org/data/2.5/forecast?zip=35137,IT&appid=';


  //api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}

  Future<Map<String, dynamic>> getData() async {

      const url = OpenWeatherUrl + APIkey;

      print('Calling: $url');
      final response = await http.get(Uri.parse(url));
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      return decodedResponse;
  
  }
}



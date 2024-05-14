import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Openweather{
  static const APIkey = '1e52585354b785f5d9f0959bcbe3ddb1';
  static const dataUrl = 'http://api.openweathermap.org/data/2.5/forecast?';
  static const historicalUrl = 'http://api.openweathermap.org/data/2.5/history/city?';
  static const coordinatesUrl = 'http://api.openweathermap.org/geo/1.0/zip?zip=';
  static const ITUrl = ',IT&appid=';


  Future<Map<String, dynamic>> getData() async {

    final coordinates = await getCoordinatesUrl(35137); 
    final url = dataUrl+coordinates+ITUrl+APIkey;

    print('Calling: $url');
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  
  }

  Future<Map<String, dynamic>> getHistoricalData() async {
    final coordinates = await getCoordinatesUrl(35137);
    final url = historicalUrl+coordinates+ITUrl+APIkey;

    print('Calling: $url');
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  
  }

  Future<String> getCoordinatesUrl(int zipCode) async{
    final zip = zipCode.toString();
    final url = coordinatesUrl+zip+ITUrl+APIkey;
    
    final response = await http.get(Uri.parse(url));
    final decoded = jsonDecode(response.body);
    final lat = decoded['lat'];
    final lon = decoded['lon'];
    final coordinates = 'lat=${lat.toString()}&lon=${lon.toString()}';
    return coordinates;
  }
}



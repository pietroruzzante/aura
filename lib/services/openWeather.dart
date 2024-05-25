import 'dart:convert';
import 'package:http/http.dart' as http;

class Openweather{

  static const baseUrl = 'http://api.weatherapi.com/v1';
  static const forecastUrl = '/forecast.json?';
  static const APIkey = 'cf35e151f042400d98680305241505';
  

  Future<Map<String, dynamic>> getData(String coordinates) async {
    String url;
    
    url = baseUrl+forecastUrl+'&key='+APIkey+'&q='+coordinates+'&days=4';

    //print('Calling: $url');
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  Future<String> getCoordinates(int zipCode) async{
    const OpenWeatherKey = '9eb79248952ff7bdd77ab6c7ea84ee2f';
    final zip = zipCode.toString();
    final url = 'http://api.openweathermap.org/geo/1.0/zip?zip=$zip,IT&appid=$OpenWeatherKey';
    //print('Calling: $url');
    final response = await http.get(Uri.parse(url));
    final decoded = jsonDecode(response.body);
    final lat = decoded['lat'];
    final lon = decoded['lon'];
    final coordinates = '${lat.toString()},${lon.toString()}';
    //print('coordinates: $coordinates');
    return coordinates;
  }


}

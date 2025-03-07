import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../exceptions/app_exceptions.dart';
import '../models/weather_model.dart';

class WeatherRepository {
  final http.Client client;
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  WeatherRepository({required this.client});

  Future<Weather> getCurrentWeather() async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      if (apiKey == null) {
        throw AppException('API Key no encontrado');
      }
      const countryCode = 'DO'; // Código de República Dominicana
      const city = 'Santo Domingo';

      final response = await client.get(
        Uri.parse(
          '$baseUrl?q=$city,$countryCode&appid=$apiKey&units=metric&lang=es',
        ),
      );

      if (response.statusCode != 200) {
        throw AppException('Error del servidor: ${response.statusCode}');
      }

      final jsonData = json.decode(response.body);
      return Weather.fromJson(jsonData);
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw AppException('Error obteniendo el clima: ${e.toString()}');
    }
  }
}

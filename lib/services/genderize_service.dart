import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/app_exceptions.dart';
import '../models/gender_prediction_model.dart';

class GenderizeRepository {
  final http.Client client;

  GenderizeRepository({required this.client});

  Future<GenderPrediction> predictGender(String name) async {
    try {
      final response = await client.get(
        Uri.parse('https://api.genderize.io/?name=$name'),
      );

      if (response.statusCode != 200) {
        throw GenderPredictionException(
          'Error al obtener datos: ${response.statusCode}',
          response.statusCode,
        );
      }

      final jsonData = json.decode(response.body);
      return GenderPrediction.fromJson(jsonData);
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw GenderPredictionException('Error desconocido: ${e.toString()}');
    }
  }
}

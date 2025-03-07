import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/app_exceptions.dart';
import '../models/age_prediction_model.dart';

class AgeifyRepository {
  final http.Client client;

  AgeifyRepository({required this.client});

  Future<AgePrediction> predictAge(String name) async {
    try {
      final response = await client.get(
        Uri.parse('https://api.agify.io/?name=$name'),
      );

      if (response.statusCode != 200) {
        throw AppException('Error al obtener datos: ${response.statusCode}');
      }

      final jsonData = json.decode(response.body);
      return AgePrediction.fromJson(jsonData);
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw AppException('Error desconocido: ${e.toString()}');
    }
  }
}

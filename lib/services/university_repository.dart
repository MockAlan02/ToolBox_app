import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/app_exceptions.dart';
import '../models/university_model.dart';

class UniversityRepository {
  final http.Client client;

  UniversityRepository({required this.client});

  Future<List<University>> searchUniversities(String country) async {
    try {
      final sanitizedCountry = _sanitizeCountryName(country);
      final response = await client.get(
        Uri.parse(
          'http://universities.hipolabs.com/search?country=$sanitizedCountry',
        ),
      );

      if (response.statusCode != 200) {
        throw AppException(
          'Error al obtener universidades: ${response.statusCode}',
        );
      }

      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isEmpty) return [];

      return jsonData.map((uniJson) => University.fromJson(uniJson)).toList();
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw AppException('Error buscando universidades: ${e.toString()}');
    }
  }

  String _sanitizeCountryName(String country) {
    return country.trim().replaceAll(' ', '+');
  }
}

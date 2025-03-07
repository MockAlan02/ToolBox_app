import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/app_exceptions.dart';
import '../models/pokemon_model.dart';

class PokemonRepository {
  final http.Client client;

  PokemonRepository({required this.client});

  Future<Pokemon> getPokemon(String name) async {
    try {
      final response = await client.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}'),
      );

      if (response.statusCode == 404) {
        throw AppException('Pokémon no encontrado');
      }

      if (response.statusCode != 200) {
        throw AppException('Error: ${response.statusCode}');
      }

      final jsonData = json.decode(response.body);
      return Pokemon.fromJson(jsonData);
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw AppException('Error buscando Pokémon: ${e.toString()}');
    }
  }
}

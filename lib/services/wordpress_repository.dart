import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/app_exceptions.dart';
import '../models/wordpress_post_model.dart';

class WordPressRepository {
  final http.Client client;
  static const String apiUrl =
      'https://tu-sitio-wordpress.com/wp-json/wp/v2/posts';

  WordPressRepository({required this.client});

  Future<List<WordPressPost>> getLatestPosts() async {
    try {
      final response = await client.get(Uri.parse('$apiUrl?_embed&per_page=3'));

      if (response.statusCode != 200) {
        throw AppException('Error: ${response.statusCode}');
      }

      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((post) => WordPressPost.fromJson(post)).toList();
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw AppException('Error obteniendo noticias: ${e.toString()}');
    }
  }
}

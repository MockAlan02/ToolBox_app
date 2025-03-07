import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/wordpress_post_model.dart';
import '../services/wordpress_repository.dart';
import '../exceptions/app_exceptions.dart';
import 'package:http/http.dart' as http;

class WordPressNewsPage extends StatefulWidget {
  const WordPressNewsPage({super.key});

  @override
  _WordPressNewsPageState createState() => _WordPressNewsPageState();
}

class _WordPressNewsPageState extends State<WordPressNewsPage> {
  final WordPressRepository _repository = WordPressRepository(
    client: http.Client(),
  );
  List<WordPressPost> _posts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final posts = await _repository.getLatestPosts();
      setState(() => _posts = posts);
    } on AppException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Últimas Noticias')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _posts.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return _NewsCard(post: post, onTap: _launchUrl);
                },
              ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final WordPressPost post;
  final Function(String) onTap;

  const _NewsCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.featuredImage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Image.network(
                  post.featuredImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Text(
              post.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              post.excerpt,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Publicado: ${_formatDate(post.date)}',
                  style: const TextStyle(fontSize: 12),
                ),
                TextButton(
                  onPressed: () => onTap(post.link),
                  child: const Row(
                    children: [
                      Text('Leer más'),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../models/university_model.dart';
import '../services/university_repository.dart';
import '../exceptions/app_exceptions.dart';

class UniversitySearchPage extends StatefulWidget {
  const UniversitySearchPage({super.key});

  @override
  _UniversitySearchPageState createState() => _UniversitySearchPageState();
}

class _UniversitySearchPageState extends State<UniversitySearchPage> {
  final TextEditingController _countryController = TextEditingController();
  final UniversityRepository _repository = UniversityRepository(
    client: http.Client(),
  );
  List<University> _universities = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchUniversities() async {
    final country = _countryController.text.trim();

    if (country.isEmpty) {
      setState(() => _errorMessage = 'Ingrese un país válido');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _universities = [];
    });

    try {
      final result = await _repository.searchUniversities(country);
      setState(() => _universities = result);
    } on AppException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null || url.isEmpty) return;

    String formattedUrl = url;
    // Agregar esquema si no está presente
    if (!formattedUrl.startsWith('http://') &&
        !formattedUrl.startsWith('https://')) {
      formattedUrl = 'http://$formattedUrl';
    }

    final uri = Uri.parse(formattedUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al abrir enlace: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Universidades')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Ingrese un país (en inglés)',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
                hintText: 'Ej: Dominican Republic',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _searchUniversities,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Buscar Universidades'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (_universities.isNotEmpty)
              Expanded(
                child: _UniversityList(
                  universities: _universities,
                  onTapWebsite: _launchUrl,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _countryController.dispose();
    super.dispose();
  }
}

class _UniversityList extends StatelessWidget {
  final List<University> universities;
  final Function(String?) onTapWebsite;

  const _UniversityList({
    required this.universities,
    required this.onTapWebsite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20),
      itemCount: universities.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final university = universities[index];
        return ListTile(
          title: Text(university.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (university.domain != null)
                Text('Dominio: ${university.domain!}'),
              if (university.webPage != null)
                InkWell(
                  onTap: () => onTapWebsite(university.webPage),
                  child: Text(
                    'Sitio web',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
          leading: const Icon(Icons.school),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
  }
}

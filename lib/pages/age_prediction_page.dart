import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../exceptions/app_exceptions.dart';
import '../models/age_prediction_model.dart';
import '../services/ageify_repository.dart';

class AgePredictionPage extends StatefulWidget {
  const AgePredictionPage({super.key});

  @override
  _AgePredictionPageState createState() => _AgePredictionPageState();
}

class _AgePredictionPageState extends State<AgePredictionPage> {
  final TextEditingController _nameController = TextEditingController();
  final AgeifyRepository _repository = AgeifyRepository(client: http.Client());
  AgePrediction? _prediction;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _getAgePrediction() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Ingrese un nombre válido');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _prediction = null;
    });

    try {
      final result = await _repository.predictAge(name);
      setState(() => _prediction = result);
    } on AppException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getAgeCategory(int age) {
    if (age >= 6 && age <= 12) return 'Niño(a)';
    if (age < 30) return 'Joven';
    if (age < 60) return 'Adulto';
    return 'Anciano';
  }

  String _getImageAsset(int age) {
    if (age >= 6 && age <= 12) return 'assets/img/kid.png';
    if (age < 30) return 'assets/img/young.png';
    if (age < 60) return 'assets/img/adult.png';
    return 'assets/img/old.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predecir Edad')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ingrese un nombre',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.person_search),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _getAgePrediction,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Predecir Edad'),
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
            if (_prediction != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: _AgePredictionResult(
                  prediction: _prediction!,
                  category: _getAgeCategory(_prediction!.age),
                  imagePath: _getImageAsset(_prediction!.age),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

class _AgePredictionResult extends StatelessWidget {
  final AgePrediction prediction;
  final String category;
  final String imagePath;

  const _AgePredictionResult({
    required this.prediction,
    required this.category,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(imagePath, height: 150, width: 150),
        const SizedBox(height: 20),
        Text(
          'Edad estimada: ${prediction.age} años',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          'Categoría: $category',
          style: const TextStyle(fontSize: 20, color: Colors.grey),
        ),
        Text(
          'Veces consultado: ${prediction.count}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

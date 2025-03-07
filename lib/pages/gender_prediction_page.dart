import 'package:flutter/material.dart';
import '../exceptions/app_exceptions.dart';
import '../models/gender_prediction_model.dart';
import '../services/genderize_service.dart';
import 'package:http/http.dart' as http;

class GenderPredictionPage extends StatefulWidget {
  const GenderPredictionPage({super.key});

  @override
  State<GenderPredictionPage> createState() => _GenderPredictionPageState();
}

class _GenderPredictionPageState extends State<GenderPredictionPage> {
  final TextEditingController _nameController = TextEditingController();
  final GenderizeRepository _repository = GenderizeRepository(
    client: http.Client(),
  );
  GenderPrediction? _prediction;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _getGenderPrediction() async {
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
      final result = await _repository.predictGender(name);
      setState(() => _prediction = result);
    } on AppException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        _prediction?.gender == 'male'
            ? Colors.blue.shade100
            : Colors.pink.shade100;

    return Scaffold(
      appBar: AppBar(title: const Text('Predicción de Género')),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ingrese su nombre',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _getGenderPrediction,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Predecir Género'),
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
                child: _PredictionResult(prediction: _prediction!),
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

class _PredictionResult extends StatelessWidget {
  final GenderPrediction prediction;

  const _PredictionResult({required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          prediction.gender == 'male' ? 'Masculino' : 'Femenino',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Probabilidad: ${(prediction.probability * 100).toStringAsFixed(1)}%',
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          'Nombre: ${prediction.name}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

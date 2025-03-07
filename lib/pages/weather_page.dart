import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart';
import '../services/weather_repository.dart';
import 'package:http/http.dart' as http;
import '../exceptions/app_exceptions.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherRepository _repository = WeatherRepository(
    client: http.Client(),
  );
  Weather? _weather;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      await dotenv.load();
      final weather = await _repository.getCurrentWeather();
      setState(() => _weather = weather);
    } on AppException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildWeatherIcon(String iconCode) {
    return Image.network(
      'https://openweathermap.org/img/wn/$iconCode@2x.png',
      width: 100,
      height: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima en RD')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      _weather?.city ?? 'República Dominicana',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildWeatherIcon(_weather?.icon ?? ''),
                    Text(
                      '${_weather?.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _weather?.description.toUpperCase() ?? '',
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    _buildWeatherDetails(),
                  ],
                ),
              ),
    );
  }

  Widget _buildWeatherDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDetailItem('Humedad', '${_weather?.humidity}%', Icons.water_drop),
        _buildDetailItem(
          'Viento',
          '${_weather?.windSpeed.toStringAsFixed(1)} m/s',
          Icons.air,
        ),
      ],
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 40),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 16)),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

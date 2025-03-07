// main.dart
import 'package:flutter/material.dart';
import 'pages/gender_prediction_page.dart';
import 'pages/age_prediction_page.dart';
import 'pages/university_search_page.dart';
import 'pages/weather_page.dart';
import 'pages/pokemon_search_page.dart';
import 'pages/wordpress_news_page.dart';
import 'pages/about_page.dart';

void main() => runApp(const ToolboxApp());

class ToolboxApp extends StatelessWidget {
  const ToolboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toolbox App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/gender': (context) => const GenderPredictionPage(),
        '/age': (context) => const AgePredictionPage(),
        '/universities': (context) => const UniversitySearchPage(),
        '/weather': (context) => const WeatherPage(),
        '/pokemon': (context) => const PokemonSearchPage(),
        '/news': (context) => const WordPressNewsPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Herramientas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset(
              'assets/img/toolbox.png', // Asegúrate de tener esta imagen en tus assets
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Selecciona una herramienta:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _features.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder:
                  (_, index) => ListTile(
                    title: Text(_features[index].title),
                    leading: Icon(_features[index].icon),
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          _features[index].route,
                        ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final String title;
  final IconData icon;
  final String route;

  _Feature(this.title, this.icon, this.route);
}

final List<_Feature> _features = [
  _Feature('Predecir Género', Icons.person, '/gender'),
  _Feature('Determinar edad', Icons.cake, '/age'),
  _Feature('Buscar universidades', Icons.school, '/universities'),
  _Feature('Clima en RD', Icons.cloud, '/weather'),
  _Feature('Buscar Pokémon', Icons.catching_pokemon, '/pokemon'),
  _Feature('Noticias WordPress', Icons.article, '/news'),
  _Feature(
    'Sobre mi',
    Icons.info,
    '/about',
  ), // Cambiado el icono a info para diferenciar
];

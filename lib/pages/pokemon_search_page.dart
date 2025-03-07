import 'package:flutter/material.dart';
import '../models/pokemon_model.dart';
import '../services/pokemon_repository.dart';
import '../exceptions/app_exceptions.dart';
import 'package:http/http.dart' as http;

class PokemonSearchPage extends StatefulWidget {
  const PokemonSearchPage({super.key});

  @override
  _PokemonSearchPageState createState() => _PokemonSearchPageState();
}

class _PokemonSearchPageState extends State<PokemonSearchPage> {
  final TextEditingController _nameController = TextEditingController();
  final PokemonRepository _repository = PokemonRepository(
    client: http.Client(),
  );
  Pokemon? _pokemon;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchPokemon() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Ingresa un nombre de Pokémon');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _pokemon = null;
    });

    try {
      final result = await _repository.getPokemon(name);
      setState(() => _pokemon = result);
    } on AppException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Pokémon')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Pokémon',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
                hintText: 'Ej: Pikachu',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _searchPokemon,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Buscar Pokémon'),
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
            if (_pokemon != null)
              Expanded(child: _PokemonDetails(pokemon: _pokemon!)),
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

class _PokemonDetails extends StatelessWidget {
  final Pokemon pokemon;

  const _PokemonDetails({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          if (pokemon.imageUrl.isNotEmpty)
            Image.network(
              pokemon.imageUrl,
              height: 200,
              loadingBuilder: (_, child, progress) {
                return progress == null
                    ? child
                    : const CircularProgressIndicator();
              },
            ),
          Text(
            pokemon.name.toUpperCase(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Experiencia base: ${pokemon.baseExperience}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          const Text(
            'Habilidades:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Wrap(
            spacing: 8,
            children:
                pokemon.abilities
                    .map((ability) => Chip(label: Text(ability)))
                    .toList(),
          ),
        ],
      ),
    );
  }
}

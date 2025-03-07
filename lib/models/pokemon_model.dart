class Pokemon {
  final String name;
  final int id;
  final int baseExperience;
  final String imageUrl;
  final List<String> abilities;

  Pokemon({
    required this.name,
    required this.id,
    required this.baseExperience,
    required this.imageUrl,
    required this.abilities,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final abilities =
        (json['abilities'] as List)
            .map((ability) => ability['ability']['name'] as String)
            .toList();

    return Pokemon(
      name: json['name'],
      id: json['id'],
      baseExperience: json['base_experience'] ?? 0,
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default'] ?? '',
      abilities: abilities,
    );
  }
}

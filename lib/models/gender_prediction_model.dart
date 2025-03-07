class GenderPrediction {
  final String gender;
  final double probability;
  final String name;

  GenderPrediction({
    required this.gender,
    required this.probability,
    required this.name,
  });

  factory GenderPrediction.fromJson(Map<String, dynamic> json) {
    return GenderPrediction(
      gender: json['gender'] ?? 'unknown',
      probability: (json['probability'] ?? 0).toDouble(),
      name: json['name'] ?? '',
    );
  }
}

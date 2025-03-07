class AgePrediction {
  final String name;
  final int age;
  final int count;

  AgePrediction({required this.name, required this.age, required this.count});

  factory AgePrediction.fromJson(Map<String, dynamic> json) {
    return AgePrediction(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      count: json['count'] ?? 0,
    );
  }
}

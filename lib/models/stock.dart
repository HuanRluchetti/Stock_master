class Stock {
  final int id;
  final String name;
  final String description;

  Stock({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

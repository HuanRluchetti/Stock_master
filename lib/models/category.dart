class Category {
  int? id;
  String name;
  String description;

  Category({this.id, required this.name, required this.description});

  // Converte os dados do banco de dados para um objeto Category
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  // Converte um objeto Category para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

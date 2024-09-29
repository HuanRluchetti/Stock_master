class Product {
  final String barCode;
  final int stockId;
  final String name;
  final String? image;
  final double minQuantity;
  final String typeQuantity;
  final DateTime expiryDate;
  final DateTime registrationDate;
  final int categoryId;
  final num paidValue;

  Product({
    required this.barCode,
    required this.stockId,
    required this.name,
    this.image,
    required this.minQuantity,
    required this.typeQuantity,
    required this.expiryDate,
    required this.registrationDate,
    required this.categoryId,
    required this.paidValue,
  });

  // Método para converter um produto para um Map (para inserir no banco)
  Map<String, dynamic> toMap() {
    return {
      'bar_code': barCode,
      'stock_id': stockId,
      'name': name,
      'image': image,
      'min_quantity': minQuantity,
      'type_quantity': typeQuantity,
      'expiry_date': expiryDate.toIso8601String(),
      'registration_date': registrationDate.toIso8601String(),
      'category_id': categoryId,
      'paid_value': paidValue,
    };
  }

  // Método para criar um objeto Product a partir de um Map (consulta do banco)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      barCode: map['bar_code'],
      stockId: map['stock_id'],
      name: map['name'],
      image: map['image'],
      minQuantity: map['min_quantity'],
      typeQuantity: map['type_quantity'],
      expiryDate: DateTime.parse(map['expiry_date']),
      registrationDate: DateTime.parse(map['registration_date']),
      categoryId: map['category_id'],
      paidValue: map['paid_value'],
    );
  }
}

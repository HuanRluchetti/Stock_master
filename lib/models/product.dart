class Product {
  final int id;
  final String barCode;
  final int stockId;
  final String name;
  final String image;
  final double quantity;
  final double minQuantity;
  final String typeQuantity;
  final DateTime expiryDate;
  final DateTime registrationDate;
  final int categoryId;
  final double paidValue;

  Product({
    required this.id,
    required this.barCode,
    required this.stockId,
    required this.name,
    required this.image,
    required this.quantity,
    required this.minQuantity,
    required this.typeQuantity,
    required this.expiryDate,
    required this.registrationDate,
    required this.categoryId,
    required this.paidValue,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      barCode: map['bar_code'],
      stockId: map['stock_id'],
      name: map['name'],
      image: map['image'],
      quantity: map['quantity'],
      minQuantity: map['min_quantity'],
      typeQuantity: map['type_quantity'],
      expiryDate: DateTime.parse(map['expiry_date']),
      registrationDate: DateTime.parse(map['registration_date']),
      categoryId: map['category_id'],
      paidValue: map['paid_value'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bar_code': barCode,
      'stock_id': stockId,
      'name': name,
      'image': image,
      'quantity': quantity,
      'min_quantity': minQuantity,
      'type_quantity': typeQuantity,
      'expiry_date': expiryDate.toIso8601String(),
      'registration_date': registrationDate.toIso8601String(),
      'category_id': categoryId,
      'paid_value': paidValue,
    };
  }
}

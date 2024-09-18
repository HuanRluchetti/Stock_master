class Product {
  String barCode;
  int stockId;
  String name;
  String? image;
  double minQuantity;
  String typeQuantity;
  String? expiryDate;
  String registrationDate;
  int categoryId;
  double paidValue;

  Product({
    required this.barCode,
    required this.stockId,
    required this.name,
    this.image,
    required this.minQuantity,
    required this.typeQuantity,
    this.expiryDate,
    required this.registrationDate,
    required this.categoryId,
    required this.paidValue,
  });

  // Converter de Map para Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      barCode: map['bar_code'],
      stockId: map['stock_id'],
      name: map['name'],
      image: map['image'],
      minQuantity: map['min_quantity'],
      typeQuantity: map['type_quantity'],
      expiryDate: map['expiry_date'],
      registrationDate: map['registration_date'],
      categoryId: map['category_id'],
      paidValue: map['paid_value'],
    );
  }

  // Converter Product para Map
  Map<String, dynamic> toMap() {
    return {
      'bar_code': barCode,
      'stock_id': stockId,
      'name': name,
      'image': image,
      'min_quantity': minQuantity,
      'type_quantity': typeQuantity,
      'expiry_date': expiryDate,
      'registration_date': registrationDate,
      'category_id': categoryId,
      'paid_value': paidValue,
    };
  }
}

class Stock {
  int? id;
  String barCode;
  String name;
  String? description;
  double quantity;
  double paidValue;
  double salePrice;
  DateTime expiryDate;
  DateTime entryDate;

  Stock({
    this.id,
    required this.barCode,
    required this.name,
    this.description,
    required this.quantity,
    required this.paidValue,
    required this.salePrice,
    required this.expiryDate,
    required this.entryDate,
  });

  // Converte os dados do banco de dados para um objeto Stock
  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'],
      barCode: map['bar_code'],
      name: map['name'],
      description: map['description'],
      quantity: map['quantity'],
      paidValue: map['paid_value'],
      salePrice: map['sale_price'],
      expiryDate: DateTime.parse(map['expiry_date']),
      entryDate: DateTime.parse(map['entry_date']),
    );
  }

  // Converte um objeto Stock para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bar_code': barCode,
      'name': name,
      'description': description,
      'quantity': quantity,
      'paid_value': paidValue,
      'sale_price': salePrice,
      'expiry_date': expiryDate.toIso8601String(),
      'entry_date': entryDate.toIso8601String(),
    };
  }
}

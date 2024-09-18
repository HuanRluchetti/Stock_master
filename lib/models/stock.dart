class Stock {
  int? id;
  String name;
  String? description;
  double? quantity;
  double? paidValue;
  double? salePrice;
  String? expiryDate;
  String? entryDate;

  Stock({
    this.id,
    required this.name,
    this.description,
    this.quantity,
    this.paidValue,
    this.salePrice,
    this.expiryDate,
    this.entryDate,
  });

  // Converter de Map para Stock
  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      quantity: map['quantity'],
      paidValue: map['paid_value'],
      salePrice: map['sale_price'],
      expiryDate: map['expiry_date'],
      entryDate: map['entry_date'],
    );
  }

  // Converter Stock para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'paid_value': paidValue,
      'sale_price': salePrice,
      'expiry_date': expiryDate,
      'entry_date': entryDate,
    };
  }
}

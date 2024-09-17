class StockMovement {
  final int id;
  final int productId;
  final String product;
  final String stock;
  final String category;
  final String movementType;
  final String quantity;
  final String typeQuantity;
  final DateTime movementDate;
  final double totalValue;

  StockMovement({
    required this.id,
    required this.productId,
    required this.product,
    required this.stock,
    required this.category,
    required this.movementType,
    required this.quantity,
    required this.typeQuantity,
    required this.movementDate,
    required this.totalValue,
  });

  factory StockMovement.fromMap(Map<String, dynamic> map) {
    return StockMovement(
      id: map['id'],
      productId: map['product_id'],
      product: map['product'],
      stock: map['stock'],
      category: map['category'],
      movementType: map['movement_type'],
      quantity: map['quantity'],
      typeQuantity: map['type_quantity'],
      movementDate: DateTime.parse(map['movement_date']),
      totalValue: map['total_value'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'product': product,
      'stock': stock,
      'category': category,
      'movement_type': movementType,
      'quantity': quantity,
      'type_quantity': typeQuantity,
      'movement_date': movementDate.toIso8601String(),
      'total_value': totalValue,
    };
  }
}

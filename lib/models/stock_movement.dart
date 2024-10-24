class StockMovement {
  final int? id;
  final int productId; 
  final int? stockId;
  final String movementType;
  final double quantity;
  final DateTime movementDate;

  StockMovement({
    this.id,
    required this.productId,
    this.stockId,
    required this.movementType,
    required this.quantity,
    required this.movementDate,
  });

  // Método para converter um Map em um objeto StockMovement
  factory StockMovement.fromMap(Map<String, dynamic> map) {
    return StockMovement(
      id: map['id'],
      productId: map['product_id'], 
      stockId: map['stock_id'],
      movementType: map['movement_type'],
      quantity: map['quantity'],
      movementDate: DateTime.parse(map['movement_date']),
    );
  }

  // Método para converter um objeto StockMovement em um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId, // Ajuste para product_id
      'stock_id': stockId,
      'movement_type': movementType,
      'quantity': quantity,
      'movement_date': movementDate.toIso8601String(),
    };
  }
}
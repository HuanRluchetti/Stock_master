class StockMovement {
  int? id;
  String barCode;
  String stockId;
  String movementType;
  double quantity;
  DateTime movementDate;

  StockMovement({
    this.id,
    required this.barCode,
    required this.stockId,
    required this.movementType,
    required this.quantity,
    required this.movementDate,
  });

  // Converte os dados do banco de dados para um objeto StockMovement
  factory StockMovement.fromMap(Map<String, dynamic> map) {
    return StockMovement(
      id: map['id'],
      barCode: map['bar_code'],
      stockId: map['stock_id'],
      movementType: map['movement_type'],
      quantity: double.parse(map['quantity'].toString()),
      movementDate: DateTime.parse(map['movement_date']),
    );
  }

  // Converte um objeto StockMovement para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bar_code': barCode,
      'stock_id': stockId,
      'movement_type': movementType,
      'quantity': quantity,
      'movement_date': movementDate.toIso8601String(),
    };
  }
}

class StockMovement {
  int? id;
  String barCode;
  int stockId;
  String movimentType;
  double quantity;
  String movimentDate;

  StockMovement({
    this.id,
    required this.barCode,
    required this.stockId,
    required this.movimentType,
    required this.quantity,
    required this.movimentDate,
  });

  // Converter de Map para StockMovement
  factory StockMovement.fromMap(Map<String, dynamic> map) {
    return StockMovement(
      id: map['id'],
      barCode: map['bar_code'],
      stockId: map['stock_id'],
      movimentType: map['moviment_type'],
      quantity: map['quantity'],
      movimentDate: map['moviment_date'],
    );
  }

  // Converter StockMovement para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bar_code': barCode,
      'stock_id': stockId,
      'moviment_type': movimentType,
      'quantity': quantity,
      'moviment_date': movimentDate,
    };
  }
}

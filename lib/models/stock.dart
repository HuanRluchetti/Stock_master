class Stock {
  final int? id;
  final int productId;
  final double quantity;
  final double paidValue;
  final double salePrice;
  final DateTime expiryDate;
  final DateTime entryDate;

  Stock({
    this.id,
    required this.productId,
    required this.quantity,
    required this.paidValue,
    required this.salePrice,
    required this.expiryDate,
    required this.entryDate,
  });

  // Converte um mapa do banco de dados para um objeto Stock
factory Stock.fromMap(Map<String, dynamic> map) {
  return Stock(
    id: map['id'] as int?,
    productId: map['product_id'] is int
        ? map['product_id'] as int
        : int.parse(map['product_id'].toString()), // Converte para int se necessário
    quantity: map['quantity'] is double
        ? map['quantity'] as double
        : (map['quantity'] as num).toDouble(), // Garante double
    paidValue: (map['paid_value'] ?? 0.0) as double, // Valor padrão se nulo
    salePrice: (map['sale_price'] ?? 0.0) as double, // Valor padrão se nulo
    expiryDate: _parseDate(map['expiry_date']), // Trata datas nulas ou inválidas
    entryDate: _parseDate(map['entry_date']), // Mesmo tratamento para entryDate
  );
}

static DateTime _parseDate(dynamic date) {
  if (date == null || date.toString().isEmpty) {
    return DateTime.now(); // Usa a data atual se for nulo ou vazio
  }
  final parsedDate = DateTime.tryParse(date.toString());
  if (parsedDate != null) {
    return parsedDate; // Retorna a data válida
  } else {
    throw FormatException('Formato de data inválido: $date'); // Lança exceção se inválido
  }
}

  // Converte um objeto Stock para um mapa do banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'paid_value': paidValue,
      'sale_price': salePrice,
      'expiry_date': expiryDate.toIso8601String(),
      'entry_date': entryDate.toIso8601String(),
    };
  }
}
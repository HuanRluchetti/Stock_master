class Product {
  final int? id; // Incluímos o campo id.
  final String barCode;
  final String name;
  final double minQuantity;
  final String typeQuantity;
  final DateTime expiryDate;
  final DateTime registrationDate;
  final int categoryId;
  final double paidValue;

  Product({
    this.id, // O id pode ser nulo para novos produtos.
    required this.barCode,
    required this.name,
    required this.minQuantity,
    required this.typeQuantity,
    required this.expiryDate,
    required this.registrationDate,
    required this.categoryId,
    required this.paidValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bar_code': barCode,
      'name': name,
      'min_quantity': minQuantity,
      'type_quantity': typeQuantity,
      'expiry_date': expiryDate.toIso8601String(),
      'registration_date': registrationDate.toIso8601String(),
      'category_id': categoryId,
      'paid_value': paidValue,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      barCode: map['bar_code']?.toString() ??
          '', // Garante que seja uma String não nula
      name: map['name']?.toString() ??
          'Produto Desconhecido', // Nome padrão se nulo
      minQuantity: (map['min_quantity'] as num?)?.toDouble() ??
          0.0, // Converte ou usa 0.0
      typeQuantity:
          map['type_quantity']?.toString() ?? '', // Garante uma String não nula
      expiryDate: _parseDate(map['expiry_date']), // Trata data de validade
      registrationDate:
          _parseDate(map['registration_date']), // Trata data de registro
      categoryId: map['category_id'] as int? ?? -1, // Categoria padrão se nulo
      paidValue: (map['paid_value'] as num?)?.toDouble() ??
          0.0, // Valor padrão se nulo
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null || date.toString().isEmpty) {
      return DateTime.now(); // Fallback para a data atual
    }
    final parsedDate = DateTime.tryParse(date.toString());
    if (parsedDate != null) {
      return parsedDate; // Retorna a data válida
    } else {
      return DateTime.now(); // Retorna a data atual se inválido
    }
  }
}

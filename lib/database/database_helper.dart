import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../models/category.dart';
import '../models/product.dart';
import '../models/stock.dart';
import '../models/stock_movement.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'stock_master.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE category (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT
          )
        ''');

        await db.execute('''
        CREATE TABLE product (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          bar_code TEXT UNIQUE,
          stock_id INTEGER,
          name TEXT NOT NULL,
          type_quantity TEXT,
          min_quantity REAL,
          expiry_date TEXT,
          registration_date TEXT,
          category_id INTEGER,
          paid_value REAL,
          FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE SET NULL
        );
        ''');

        await db.execute('''
          CREATE TABLE stock (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id INTEGER,
            quantity REAL,
            paid_value REAL,
            sale_price REAL,
            expiry_date TEXT,
            entry_date TEXT,
            FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE stock_movement (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id INTEGER NOT NULL,
            stock_id INTEGER,
            movement_type TEXT NOT NULL,
            quantity REAL NOT NULL,
            movement_date TEXT NOT NULL,
            total_value REAL,
            FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future<int> insertCategory(Category category) async {
    final db = await database;

    if (category.name.isEmpty) {
      throw Exception('O nome da categoria é obrigatório.');
    }

    try {
      return await db.insert(
        'category',
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Erro ao inserir categoria: $e');
      rethrow;
    }
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      'category',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Category?> getCategoryById(int id) async {
    final db = await database;
    final result = await db.query(
      'category',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Category.fromMap(result.first);
    }
    return null;
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final result = await db.query('category');
    return result.map((map) => Category.fromMap(map)).toList();
  }

  Future<Stock?> getStockByProductId(int productId) async {
    final db = await database;
    final result = await db.query(
      'stock',
      where: 'product_id = ?',
      whereArgs: [productId],
    );

    if (result.isNotEmpty) {
      return Stock.fromMap(result.first);
    }
    return null;
  }

  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert(
      'product',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      'product',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }
Future<void> insertOrUpdateStock(Stock stock) async {
  final db = await database;

  // Verifica se o estoque já existe para o produto
  final result = await db.query(
    'stock',
    where: 'product_id = ?',
    whereArgs: [stock.productId],
  );

  if (result.isNotEmpty) {
    // Atualiza o estoque existente
    await db.update(
      'stock',
      stock.toMap(),
      where: 'product_id = ?',
      whereArgs: [stock.productId],
    );
  } else {
    // Insere um novo registro de estoque
    await db.insert('stock', stock.toMap());
  }
}

  Future<List<Map<String, dynamic>>> searchProductsWithStock(
      String query) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT p.*, IFNULL(s.quantity, 0) AS quantity
    FROM product p
    LEFT JOIN stock s ON p.id = s.product_id
    WHERE p.name LIKE ? OR p.bar_code LIKE ?
  ''', ['%$query%', '%$query%']);
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllProductsWithStock() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT p.*, IFNULL(s.quantity, 0) AS quantity
    FROM product p
    LEFT JOIN stock s ON p.id = s.product_id
  ''');
    return result;
  }

  Future<void> deleteProduct(String barCode) async {
    final db = await database;
    await db.delete(
      'product',
      where: 'bar_code = ?',
      whereArgs: [barCode],
    );
  }

  Future<List<Product>> getProductsBelowMinQuantity() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT p.* FROM product p
    INNER JOIN stock s ON p.id = s.product_id
    WHERE s.quantity < p.min_quantity
  ''');
    return result.map((map) => Product.fromMap(map)).toList();
  }

  // Inserir um novo estoque
  Future<int> insertStock(Stock stock) async {
    final db = await database;
    return await db.insert(
      'stock',
      stock.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Atualizar estoque existente
  Future<int> updateStock(Stock stock) async {
    final db = await database;
    return await db.update(
      'stock',
      stock.toMap(),
      where: 'id = ?',
      whereArgs: [stock.id],
    );
  }

  // Deletar estoque pelo ID
  Future<int> deleteStock(int id) async {
    final db = await database;
    return await db.delete(
      'stock',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Stock>> getAllStock() async {
    final db = await database;
    final result = await db.query('stock');

    return result.map((map) => Stock.fromMap(map)).toList();
  }

  Future<String?> getProductName(String productId) async {
    final db = await database;
    final result = await db.query(
      'product',
      columns: ['name'],
      where: 'bar_code = ?',
      whereArgs: [productId],
    );

    if (result.isNotEmpty) {
      return result.first['name'] as String?;
    }
    return null;
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final result = await db.query('product');
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<void> insertStockMovement(StockMovement movement) async {
    final db = await database;
    await db.insert('stock_movement', movement.toMap());
  }

  Future<void> updateStockQuantity(StockMovement movement) async {
    final db = await database;

    // Recuperar o estoque atual
    final stockResult = await db.query(
      'stock',
      where: 'id = ?',
      whereArgs: [movement.stockId],
    );

    if (stockResult.isNotEmpty) {
      final currentStock = Stock.fromMap(stockResult.first);

      // Atualiza a quantidade de acordo com o tipo de movimento
      final updatedQuantity = movement.movementType == 'entrada'
          ? currentStock.quantity + movement.quantity
          : currentStock.quantity - movement.quantity;

      await db.update(
        'stock',
        {'quantity': updatedQuantity},
        where: 'id = ?',
        whereArgs: [movement.stockId],
      );
    }
  }

  Future<List<StockMovement>> getAllStockMovements() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('stock_movement');

    return result.map((map) => StockMovement.fromMap(map)).toList();
  }

  Future<Stock?> getStockByBarCode(String barCode) async {
    final db = await database;

    // Consulta com JOIN para buscar estoque com base no bar_code
    final result = await db.rawQuery('''
    SELECT stock.id, stock.product_id, stock.quantity
    FROM stock
    INNER JOIN product ON stock.product_id = product.id
    WHERE product.bar_code = ?
  ''', [barCode]);

    if (result.isNotEmpty) {
      return Stock.fromMap(result.first);
    }
    return null;
  }

  Future<Product?> getProductByBarCode(String barCode) async {
    final db = await database;

    try {
      // Consulta o banco de dados para encontrar o produto pelo código de barras
      final result = await db.query(
        'product',
        where: 'bar_code = ?',
        whereArgs: [barCode],
      );

      if (result.isNotEmpty) {
        // Retorna o primeiro produto encontrado
        return Product.fromMap(result.first);
      }
    } catch (e) {
      print('Erro ao buscar produto pelo código de barras: $e');
    }

    return null; // Retorna null se o produto não for encontrado
  }

  Future<List<Map<String, dynamic>>> getAllStockWithProducts() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT product.id, product.name, product.bar_code, 
            stock.quantity, product.min_quantity
      FROM stock
      INNER JOIN product ON stock.product_id = product.id
  ''');
  }

  Future<List<Map<String, dynamic>>> searchStockWithProducts(
      String query) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT product.id, product.name, product.bar_code, 
           stock.quantity, product.min_quantity
    FROM stock
    INNER JOIN product ON stock.product_id = product.id
    WHERE product.name LIKE ? OR product.bar_code LIKE ?
  ''', ['%$query%', '%$query%']);
  }
}

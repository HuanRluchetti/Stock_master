import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../models/stock.dart';
import '../models/stock_movement.dart';

class DatabaseHelper {
  static final _databaseName = "app_database.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Criação da tabela product
    await db.execute('''
      CREATE TABLE product (
        bar_code TEXT PRIMARY KEY,
        stock_id INTEGER,
        name TEXT,
        image TEXT,
        min_quantity REAL,
        type_quantity TEXT,
        expiry_date TEXT,
        registration_date TEXT,
        category_id INTEGER,
        paid_value NUMERIC
      )
    ''');

    // Criação da tabela stock_movement
    await db.execute('''
      CREATE TABLE stock_movement (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bar_code TEXT,
        stock_id INTEGER,
        movement_type TEXT,
        quantity TEXT,
        movement_date TEXT
      )
    ''');

    // Criação da tabela stock
    await db.execute('''
      CREATE TABLE stock (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bar_code TEXT,
        name TEXT,
        description TEXT,
        quantity REAL,
        paid_value REAL,
        sale_price REAL,
        expiry_date TEXT,
        entry_date TEXT
      )
    ''');

    // Criação da tabela category
    await db.execute('''
      CREATE TABLE category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT
      )
    ''');
  }

  Future<void> insertProduct(Product product) async {
    final db = await database;

    await db.insert(
      'product',
      product.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Substitui em caso de conflito
    );
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('product');

    // Converte cada Map (linha do banco de dados) para um objeto Product
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;

    return await db.update(
      'product',
      product.toMap(),
      where: 'bar_code = ?',
      whereArgs: [product.barCode],
    );
  }

  Future<int> deleteProduct(String barCode) async {
    final db = await database;

    return await db.delete(
      'product',
      where: 'bar_code = ?',
      whereArgs: [barCode],
    );
  }

  // Inserir uma nova categoria
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('category', category.toMap());
  }

// Listar todas as categorias
  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('category');

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

// Buscar uma categoria pelo ID
  Future<Category?> getCategoryById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'category',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Category.fromMap(result.first);
    }
    return null;
  }

  // Função para atualizar uma categoria
  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  // Função para deletar uma categoria pelo ID
  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      'category',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Inserir um novo item de estoque
  Future<int> insertStock(Stock stock) async {
    final db = await database;
    return await db.insert('stock', stock.toMap());
  }

// Listar todos os itens de estoque
  Future<List<Stock>> getAllStock() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('stock');

    return List.generate(maps.length, (i) {
      return Stock.fromMap(maps[i]);
    });
  }

// Buscar um item de estoque pelo ID
  Future<Stock?> getStockById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'stock',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Stock.fromMap(result.first);
    }
    return null;
  }

// Atualizar um item de estoque
  Future<int> updateStock(Stock stock) async {
    final db = await database;
    return await db.update(
      'stock',
      stock.toMap(),
      where: 'id = ?',
      whereArgs: [stock.id],
    );
  }

  // Inserir uma nova movimentação de estoque
  Future<int> insertStockMovement(StockMovement stockMovement) async {
    final db = await database;
    return await db.insert('stock_movement', stockMovement.toMap());
  }
  // Atualizar uma movimentação de estoque existente
Future<int> updateStockMovement(StockMovement stockMovement) async {
  final db = await database;

  return await db.update(
    'stock_movement',
    stockMovement.toMap(),
    where: 'id = ?',
    whereArgs: [stockMovement.id],
  );
}

// Listar todas as movimentações de estoque
  Future<List<StockMovement>> getAllStockMovements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('stock_movement');

    return List.generate(maps.length, (i) {
      return StockMovement.fromMap(maps[i]);
    });
  }

  // Atualiza a quantidade em estoque após a movimentação
  Future<void> updateStockQuantity(StockMovement stockMovement) async {
    final db = await database;

    // Obtém o item de estoque correspondente ao código de barras
    List<Map<String, dynamic>> stockData = await db.query(
      'stock',
      where: 'bar_code = ?',
      whereArgs: [stockMovement.barCode],
    );

    if (stockData.isNotEmpty) {
      Stock stock = Stock.fromMap(stockData.first);

      // Atualiza a quantidade de acordo com o tipo de movimentação (entrada ou saída)
      if (stockMovement.movementType == 'Entrada') {
        stock.quantity += stockMovement.quantity;
      } else if (stockMovement.movementType == 'Saída') {
        stock.quantity -= stockMovement.quantity;
      }

      // Atualiza o estoque no banco de dados
      await db.update(
        'stock',
        stock.toMap(),
        where: 'id = ?',
        whereArgs: [stock.id],
      );
    }
  }

  // Função para deletar um produto do estoque pelo ID
  Future<int> deleteStock(int id) async {
    final db = await database;
    return await db.delete(
      'stock',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // Buscar produtos abaixo do estoque mínimo
  Future<List<Product>> getProductsBelowMinStock() async {
    final db = await database;

    // Buscando produtos abaixo da quantidade mínima
    final result = await db.rawQuery('''
      SELECT product.* FROM product
      JOIN stock ON product.bar_code = stock.bar_code
      WHERE stock.quantity < product.min_quantity
    ''');

    return List.generate(result.length, (i) {
      return Product.fromMap(result[i]);
    });
  }
  // Buscar produtos próximos ao vencimento (ex: dentro de 30 dias)
Future<List<Product>> getProductsNearExpiration() async {
  final db = await database;
  final now = DateTime.now();
  final in30Days = now.add(Duration(days: 30)).toIso8601String();

  final result = await db.rawQuery('''
    SELECT * FROM product
    WHERE expiry_date > ? AND expiry_date <= ?
  ''', [now.toIso8601String(), in30Days]);

  return List.generate(result.length, (i) {
    return Product.fromMap(result[i]);
  });
}

  // Buscar produtos vencidos
  Future<List<Product>> getExpiredProducts() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final result = await db.rawQuery('''
      SELECT * FROM product
      WHERE expiry_date < ?
    ''', [now]);

    return List.generate(result.length, (i) {
      return Product.fromMap(result[i]);
    });
  }
  // Buscar movimentações entre duas datas
  Future<List<StockMovement>> getMovementsByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT * FROM stock_movement
      WHERE movement_date BETWEEN ? AND ?
      ORDER BY movement_date DESC
    ''', [startDate.toIso8601String(), endDate.toIso8601String()]);

    return List.generate(result.length, (i) {
      return StockMovement.fromMap(result[i]);
    });
  }
}

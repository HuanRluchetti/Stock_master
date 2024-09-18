import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static Database? _database;

  // Método para inicializar o banco de dados
  Future<Database> initDB() async {
    if (_database != null) {
      return _database!;
    }

    // Define o caminho onde o banco de dados será salvo
    String path = await getDatabasesPath();
    String dbPath = join(path, 'stock_management.db');

    // Abre ou cria o banco de dados
    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );

    return _database!;
  }

  // Método que cria as tabelas quando o banco de dados é inicializado pela primeira vez
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE stock (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        quantity REAL NOT NULL,
        paid_value REAL,
        sale_price REAL,
        expiry_date TEXT,
        entry_date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE product (
        bar_code TEXT PRIMARY KEY,
        stock_id INTEGER,
        name TEXT NOT NULL,
        image TEXT,
        min_quantity REAL,
        type_quantity TEXT,
        expiry_date TEXT,
        registration_date TEXT NOT NULL,
        category_id INTEGER,
        paid_value REAL,
        FOREIGN KEY(stock_id) REFERENCES stock(id),
        FOREIGN KEY(category_id) REFERENCES category(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE stock_movement (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bar_code TEXT,
        stock_id INTEGER,
        movement_type TEXT,
        quantity REAL,
        movement_date TEXT,
        FOREIGN KEY(bar_code) REFERENCES product(bar_code),
        FOREIGN KEY(stock_id) REFERENCES stock(id)
      )
    ''');
  }

  // Método para obter a instância do banco de dados (garante que o banco seja aberto apenas uma vez)
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  // Método para fechar o banco de dados (boa prática fechar o banco ao finalizar)
  Future<void> closeDB() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}

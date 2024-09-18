import 'package:sqflite/sqflite.dart';
import '../models/stock.dart';
import '../models/stock_movement.dart';

class StockController {
  final Database db;

  StockController(this.db);

  Future<int> insertStock(Stock stock) async {
    return await db.insert('stock', stock.toMap());
  }

  Future<int> updateStock(Stock stock) async {
    final result = await db
        .update('stock', stock.toMap(), where: 'id = ?', whereArgs: [stock.id]);

    // Registrar movimentação de estoque
    if (result > 0) {
      await _insertStockMovement(stock, 'update');
    }
    return result;
  }

  Future<int> deleteStock(int id) async {
    return await db.delete('stock', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Stock>> getAllStocks() async {
    final List<Map<String, dynamic>> maps = await db.query('stock');
    return List.generate(maps.length, (i) {
      return Stock.fromMap(maps[i]);
    });
  }

  Future<Stock?> getStockById(int id) async {
    final List<Map<String, dynamic>> maps =
        await db.query('stock', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Stock.fromMap(maps.first);
    }
    return null;
  }

  Future<void> _insertStockMovement(Stock stock, String movimentType) async {
    final stockMovement = StockMovement(
      barCode: '', // Aqui você pode passar o código de barras do produto
      stockId: stock.id!,
      movimentType: movimentType,
      quantity: stock.quantity!,
      movimentDate: DateTime.now().toIso8601String(),
    );
    await db.insert('stock_movement', stockMovement.toMap());
  }
}

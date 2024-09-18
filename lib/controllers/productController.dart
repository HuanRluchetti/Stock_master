import 'package:sqflite/sqflite.dart';
import '../models/product.dart';

class ProductController {
  final Database db;

  ProductController(this.db);

  Future<int> insertProduct(Product product) async {
    return await db.insert('product', product.toMap());
  }

  Future<int> updateProduct(Product product) async {
    return await db.update('product', product.toMap(),
        where: 'bar_code = ?', whereArgs: [product.barCode]);
  }

  Future<int> deleteProduct(String barCode) async {
    return await db
        .delete('product', where: 'bar_code = ?', whereArgs: [barCode]);
  }

  Future<List<Product>> getAllProducts() async {
    final List<Map<String, dynamic>> maps = await db.query('product');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<Product?> getProductByBarCode(String barCode) async {
    final List<Map<String, dynamic>> maps =
        await db.query('product', where: 'bar_code = ?', whereArgs: [barCode]);
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }
}

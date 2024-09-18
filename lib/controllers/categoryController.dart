import 'package:sqflite/sqflite.dart';
import '../models/category.dart';

class CategoryController {
  final Database db;

  CategoryController(this.db);

  Future<int> insertCategory(Category category) async {
    return await db.insert('category', category.toMap());
  }

  Future<int> updateCategory(Category category) async {
    return await db.update('category', category.toMap(),
        where: 'id = ?', whereArgs: [category.id]);
  }

  Future<int> deleteCategory(int id) async {
    return await db.delete('category', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Category>> getAllCategories() async {
    final List<Map<String, dynamic>> maps = await db.query('category');
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<List<Category>> getCategories() async {
    final List<Map<String, dynamic>> maps = await db.query('category');
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<Category?> getCategoryById(int id) async {
    final List<Map<String, dynamic>> maps =
        await db.query('category', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    }
    return null;
  }
}

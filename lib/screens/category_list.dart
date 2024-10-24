import 'package:flutter/material.dart';
import '../models/category.dart';
import '../database/database_helper.dart';
import 'category_form.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late Future<List<Category>> _categoryList;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() {
    setState(() {
      _categoryList = DatabaseHelper.instance.getAllCategories();
    });
  }

  Future<void> _deleteCategory(int id) async {
    final db = DatabaseHelper.instance;
    await db.deleteCategory(id);
    _fetchCategories();
  }

  Future<void> _confirmDelete(BuildContext context, Category category) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Categoria'),
          content: Text('Tem certeza que deseja excluir "${category.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _deleteCategory(category.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Categorias'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryForm()),
              ).then((result) {
                if (result != null && result) {
                  _fetchCategories();
                }
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchCategories();
        },
        child: FutureBuilder<List<Category>>(
          future: _categoryList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar categorias.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Nenhuma categoria cadastrada.'));
            } else {
              final categories = snapshot.data!;
              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    title: Text(category.name),
                    subtitle: category.description.isNotEmpty
                        ? Text(category.description)
                        : const Text('Sem descrição'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context, category),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryForm(category: category),
                        ),
                      ).then((result) {
                        if (result != null && result) {
                          _fetchCategories();
                        }
                      });
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
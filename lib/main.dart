import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../screens/category_list.dart';
import '../screens/product_list.dart';
import '../screens/stock_list.dart';
import '../screens/stock_movement_list.dart';
import '../screens/stock_movement_form.dart';
import '../screens/shopping_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Produtos',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Master'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2, size: 64, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Stock Master',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.list,
              text: 'Listar Produtos',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductList()),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.category,
              text: 'Listar Categorias',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryList()),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.storage,
              text: 'Listar Estoque',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockList()),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.swap_horiz,
              text: 'Listar Movimentação',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StockMovementList(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.input,
              text: 'Registrar Movimentação',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StockMovementForm(
                      stockId: 1, // Exemplo de stockId
                    ),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.shopping_cart,
              text: 'Lista de Compras',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShoppingList()),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.delete_forever,
              text: 'Deletar Banco de Dados',
              onTap: () async {
                await _deleteDatabase();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Banco de dados excluído com sucesso!'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo ao Stock Master!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.list),
                label: const Text('Listar Produtos'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductList()),
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.category),
                label: const Text('Listar Categorias'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryList()),
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.storage),
                label: const Text('Listar Estoque'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StockList()),
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Listar Movimentação'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StockMovementList()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(text),
      onTap: () {
        Navigator.pop(context); // Fechar o Drawer ao navegar
        onTap();
      },
    );
  }

  Future<void> _deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'stock_master.db');
    await deleteDatabase(path);
    debugPrint('Banco de dados excluído');
  }
}
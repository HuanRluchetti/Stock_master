import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../database/database_helper.dart';

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  late Future<List<Product>> _shoppingList;

  @override
  void initState() {
    super.initState();
    _fetchShoppingList();
  }

  void _fetchShoppingList() {
    _shoppingList = DatabaseHelper.instance.getProductsBelowMinStock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _shoppingList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar lista de compras.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum produto abaixo do estoque mínimo.'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Código: ${product.barCode}'),
                  trailing: Text('Estoque mínimo: ${product.minQuantity}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
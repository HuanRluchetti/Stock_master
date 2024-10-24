import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/database_helper.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  late Future<List<Product>> _shoppingList;

  @override
  void initState() {
    super.initState();
    _fetchShoppingList();
  }

  void _fetchShoppingList() {
    setState(() {
      _shoppingList = DatabaseHelper.instance.getProductsBelowMinQuantity();
    });
  }

  Future<void> _removeProduct(Product product) async {
    await DatabaseHelper.instance.deleteProduct(product.barCode);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} removido da lista.')),
      );
      _fetchShoppingList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _shoppingList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar a lista de compras.'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum item na lista de compras.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Quantidade mínima: ${product.minQuantity}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeProduct(product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
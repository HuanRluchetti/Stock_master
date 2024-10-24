import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/database_helper.dart';
import 'stock_movement_form.dart';

class StockList extends StatefulWidget {
  const StockList({super.key});

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  late Future<List<Map<String, dynamic>>> _stockList;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStock();
  }

  // Consulta os produtos com estoque e quantidade mínima
  void _fetchStock([String? query]) {
    setState(() {
      if (query != null && query.isNotEmpty) {
        _stockList = DatabaseHelper.instance.searchStockWithProducts(query);
      } else {
        _stockList = DatabaseHelper.instance.getAllStockWithProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Estoque'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchStock, // Atualizar a lista de estoque
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por nome ou código',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () =>
                      _fetchStock(_searchController.text), // Realiza a busca
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _stockList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Exibe o erro na interface para facilitar o diagnóstico
                  return Center(
                    child: Text(
                      'Erro ao carregar o estoque: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nenhum produto em estoque.'),
                  );
                } else {
                  final stockWithProducts = snapshot.data!;
                  return ListView.builder(
                    itemCount: stockWithProducts.length,
                    itemBuilder: (context, index) {
                      final product = Product.fromMap(stockWithProducts[index]);
                      final quantity =
                          stockWithProducts[index]['quantity'] ?? 0.0;
                      final productName =
                          product.name ?? ''; // Corrige o erro de null
                      final productCode =
                          product.barCode ?? ''; // Corrige o erro de null

                      return ListTile(
                        title: Text(productName), // Nome do produto
                        subtitle:
                            Text('Código: $productCode'), // Código do produto
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Qtd: ${quantity.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: quantity < (product.minQuantity ?? 0.0)
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.info),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StockMovementForm(stockId: product.id!),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

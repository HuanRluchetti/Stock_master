import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/database_helper.dart';
import 'product_form.dart';
import 'stock_movement_form.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Future<List<Map<String, dynamic>>> _productList;
  final _searchController = TextEditingController(); // Controlador de busca

  @override
  void initState() {
    super.initState();
    _fetchProductsWithStock();
  }

  void _fetchProductsWithStock([String? query]) {
    setState(() {
      if (query != null && query.isNotEmpty) {
        _productList = DatabaseHelper.instance.searchProductsWithStock(query);
      } else {
        _productList = DatabaseHelper.instance.getAllProductsWithStock();
      }
    });
  }

  Future<void> _scanBarcode() async {
    var result = await BarcodeScanner.scan(); // Inicia o scanner
    if (result.rawContent.isNotEmpty && mounted) {
      _fetchProductsWithStock(result.rawContent); // Busca produto escaneado
    }
  }

  void _deleteProduct(String barCode) async {
    await DatabaseHelper.instance.deleteProduct(barCode);
    if (mounted) {
      _fetchProductsWithStock();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto excluído com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _scanBarcode, // Scanner de código de barras
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchProductsWithStock, // Atualizar lista
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductForm()),
              ).then((result) {
                if (result != null && result) {
                  _fetchProductsWithStock(); // Atualiza lista
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz), // Ícone de movimentação de estoque
            onPressed: () {
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
                      _fetchProductsWithStock(_searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _productList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Erro ao carregar produtos.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum produto cadastrado.'));
                } else {
                  final productsWithStock = snapshot.data!;
                  return ListView.builder(
                    itemCount: productsWithStock.length,
                    itemBuilder: (context, index) {
                      final product =
                          Product.fromMap(productsWithStock[index]);
                      final stockQuantity =
                          productsWithStock[index]['quantity'] ?? 0.0;
                      final typeQuantity =
                          product.typeQuantity ?? ''; // Tipo de quantidade

                      return Dismissible(
                        key: Key(product.barCode),
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          _deleteProduct(product.barCode);
                        },
                        child: ListTile(
                          title: Text('${product.name} (ID: ${product.id})'), // Exibindo nome e ID
                          subtitle: Text('Código de Barras: ${product.barCode}'), // Alterado para "Código de Barras"
                          trailing: Text(
                            'Qtd: ${stockQuantity.toStringAsFixed(2)} $typeQuantity', // Exibindo quantidade com tipo
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductForm(product: product),
                              ),
                            ).then((_) => _fetchProductsWithStock());
                          },
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
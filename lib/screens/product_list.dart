import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/database_helper.dart';
import 'product_form.dart';
import 'movement_report.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Future<List<Product>> _productList;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    _productList = DatabaseHelper.instance.getAllProducts();
  }

  void _deleteProduct(String barCode) async {
    await DatabaseHelper.instance.deleteProduct(barCode);
    setState(() {
      _fetchProducts();
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Produto excluído com sucesso!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
        actions: [
          IconButton(
            icon: Icon(Icons.report),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MovementReport()), // Navegar para o relatório de movimentações
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _fetchProducts(); // Atualiza a lista de produtos
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar produtos.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum produto cadastrado.'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Dismissible(
                  key: Key(product.barCode),
                  background: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white)),
                  onDismissed: (direction) {
                    _deleteProduct(product.barCode);
                  },
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text('Código: ${product.barCode}'),
                    trailing: Text('Qtd Mínima: ${product.minQuantity}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductForm(product: product)),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
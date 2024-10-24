import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/database_helper.dart';

class ExpiryList extends StatefulWidget {
  @override
  _ExpiryListState createState() => _ExpiryListState();
}

class _ExpiryListState extends State<ExpiryList> {
  late Future<List<Product>> _nearExpiryProducts;
  late Future<List<Product>> _expiredProducts;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    _nearExpiryProducts = DatabaseHelper.instance.getProductsNearExpiration();
    _expiredProducts = DatabaseHelper.instance.getExpiredProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos Próximos ao Vencimento e Vencidos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Produtos Próximos ao Vencimento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            FutureBuilder<List<Product>>(
              future: _nearExpiryProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar produtos.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum produto próximo ao vencimento.'));
                } else {
                  final products = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text('Código: ${product.barCode} - Validade: ${product.expiryDate}'),
                      );
                    },
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Produtos Vencidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            FutureBuilder<List<Product>>(
              future: _expiredProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar produtos.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum produto vencido.'));
                } else {
                  final products = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text('Código: ${product.barCode} - Validade: ${product.expiryDate}'),
                        trailing: Icon(Icons.warning, color: Colors.red),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../database/database_helper.dart';
import 'stock_form.dart';

class StockList extends StatefulWidget {
  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  late Future<List<Stock>> _stockList;

  @override
  void initState() {
    super.initState();
    _fetchStock();
  }

  void _fetchStock() {
    _stockList = DatabaseHelper.instance.getAllStock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Estoque'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StockForm()),
              ).then((_) => setState(() {
                    _fetchStock();
                  }));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Stock>>(
        future: _stockList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar estoque.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum item em estoque.'));
          } else {
            final stockItems = snapshot.data!;
            return ListView.builder(
              itemCount: stockItems.length,
              itemBuilder: (context, index) {
                final stockItem = stockItems[index];
                return ListTile(
                  title: Text(stockItem.name),
                  subtitle: Text(
                      'Quantidade: ${stockItem.quantity}, Preço de Venda: ${stockItem.salePrice}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StockForm(stock: stockItem),
                      ),
                    ).then((_) => setState(() {
                          _fetchStock();
                        }));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

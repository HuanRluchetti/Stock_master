import 'package:flutter/material.dart';
import '../models/stock_movement.dart';
import '../database/database_helper.dart';
import 'stock_movement_form.dart';

class StockMovementList extends StatefulWidget {
  @override
  _StockMovementListState createState() => _StockMovementListState();
}

class _StockMovementListState extends State<StockMovementList> {
  late Future<List<StockMovement>> _stockMovementList;

  @override
  void initState() {
    super.initState();
    _fetchStockMovements();
  }

  void _fetchStockMovements() {
    _stockMovementList = DatabaseHelper.instance.getAllStockMovements();
  }

  void _deleteMovement(int id) async {
    await DatabaseHelper.instance.deleteStockMovement(id);
    setState(() {
      _fetchStockMovements();
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Movimentação excluída com sucesso!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movimentações de Estoque'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StockMovementForm()),
              ).then((result) {
                if (result != null && result) {
                  setState(() {
                    _fetchStockMovements();
                  });
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<StockMovement>>(
        future: _stockMovementList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar movimentações.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma movimentação encontrada.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movement = snapshot.data![index];
                return ListTile(
                  title: Text('${movement.type}: ${movement.quantity} unidades - Produto: ${movement.productCode}'),
                  subtitle: Text('Data: ${movement.date}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StockMovementForm(stockMovement: movement)),
                          ).then((result) {
                            if (result != null && result) {
                              setState(() {
                                _fetchStockMovements();
                              });
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteMovement(movement.id!),
                      ),
                    ],
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

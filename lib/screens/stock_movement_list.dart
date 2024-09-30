import 'package:flutter/material.dart';
import '../models/stock_movement.dart';
import '../database/database_helper.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movimentações de Estoque'),
      ),
      body: FutureBuilder<List<StockMovement>>(
        future: _stockMovementList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar movimentações.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma movimentação registrada.'));
          } else {
            final movements = snapshot.data!;
            return ListView.builder(
              itemCount: movements.length,
              itemBuilder: (context, index) {
                final movement = movements[index];
                return ListTile(
                  title: Text('Movimentação: ${movement.movementType}'),
                  subtitle: Text(
                    'Código de Barras: ${movement.barCode}\n'
                    'Quantidade: ${movement.quantity}\n'
                    'Data: ${movement.movementDate}',
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

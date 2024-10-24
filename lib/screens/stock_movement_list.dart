import 'package:flutter/material.dart';
import '../models/stock_movement.dart';
import '../database/database_helper.dart';
import 'stock_movement_form.dart';

class StockMovementList extends StatefulWidget {
  const StockMovementList({super.key});

  @override
  State<StockMovementList> createState() => _StockMovementListState();
}

class _StockMovementListState extends State<StockMovementList> {
  late Future<List<StockMovement>> _stockMovementList;

  @override
  void initState() {
    super.initState();
    _fetchStockMovements();
  }

  void _fetchStockMovements() {
    setState(() {
      _stockMovementList = DatabaseHelper.instance.getAllStockMovements();
    });
  }

  void _navigateToMovementForm(int stockId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockMovementForm(stockId: stockId),
      ),
    );

    if (result != null && result) {
      _fetchStockMovements();
    }
  }

  void _deleteMovement(int id) async {
    await DatabaseHelper.instance.deleteStock(id);
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
        title: const Text('Movimentações de Estoque'),
      ),
      body: FutureBuilder<List<StockMovement>>(
        future: _stockMovementList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar movimentações.'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhuma movimentação encontrada.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final movement = snapshot.data![index];
              return ListTile(
                title: Text(
                  '${movement.movementType} - Produto ID: ${movement.productId}',
                ),
                subtitle: Text('Quantidade: ${movement.quantity}'),
                trailing: const Icon(Icons.info),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToMovementForm(1), 
        label: const Text('Nova Movimentação'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
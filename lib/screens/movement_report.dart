import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/stock_movement.dart';
import '../database/database_helper.dart';

class MovementReport extends StatefulWidget {
  @override
  _MovementReportState createState() => _MovementReportState();
}

class _MovementReportState extends State<MovementReport> {
  DateTime? _startDate;
  DateTime? _endDate;
  late Future<List<StockMovement>> _movements;
  double totalEntries = 0.0;
  double totalExits = 0.0;

  void _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _fetchMovements(); // Busca as movimentações com as novas datas
      });
    }
  }

  void _fetchMovements() {
    if (_startDate != null && _endDate != null) {
      _movements = DatabaseHelper.instance.getMovementsByDateRange(_startDate!, _endDate!);
      _calculateTotals();
    }
  }

  // Calcular o valor total de entradas e saídas
  void _calculateTotals() async {
    final movements = await _movements;
    double totalEntriesTemp = 0.0;
    double totalExitsTemp = 0.0;

    for (var movement in movements) {
      if (movement.movementType == 'Entrada') {
        totalEntriesTemp += movement.quantity;
      } else if (movement.movementType == 'Saída') {
        totalExitsTemp -= movement.quantity;
      }
    }

    setState(() {
      totalEntries = totalEntriesTemp;
      totalExits = totalExitsTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Movimentações'),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => _selectDateRange(context), // Abrir o seletor de intervalo de datas
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _startDate != null && _endDate != null
                  ? 'Relatório de ${DateFormat.yMd().format(_startDate!)} até ${DateFormat.yMd().format(_endDate!)}'
                  : 'Selecione o intervalo de datas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder<List<StockMovement>>(
            future: _movements,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar movimentações.'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Nenhuma movimentação encontrada no período selecionado.'));
              } else {
                final movements = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: movements.length,
                    itemBuilder: (context, index) {
                      final movement = movements[index];
                      return ListTile(
                        title: Text(movement.movementType),
                        subtitle: Text('Produto: ${movement.barCode}'),
                        trailing: Text('${movement.quantity.toString()} unidades'),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Total de Entradas: $totalEntries unidades', style: TextStyle(fontSize: 16)),
                Text('Total de Saídas: $totalExits unidades', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
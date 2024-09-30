import 'package:flutter/material.dart';
import '../models/stock_movement.dart';
import '../database/database_helper.dart';

class StockMovementForm extends StatefulWidget {
  @override
  _StockMovementFormState createState() => _StockMovementFormState();
}

class _StockMovementFormState extends State<StockMovementForm> {
  final _formKey = GlobalKey<FormState>();

  final _barCodeController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedMovementType = 'Entrada';

  void _saveMovement() async {
    if (_formKey.currentState!.validate()) {
      final movement = StockMovement(
        barCode: _barCodeController.text,
        stockId:
            '1', // Supondo que tenha um ID de estoque fixo para simplificar
        movementType: _selectedMovementType,
        quantity: double.parse(_quantityController.text),
        movementDate: DateTime.now(),
      );

      // Insere a movimentação e atualiza o estoque
      await DatabaseHelper.instance.insertStockMovement(movement);
      await DatabaseHelper.instance.updateStockQuantity(movement);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Movimentação registrada com sucesso!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Movimentação de Estoque'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _barCodeController,
                decoration: InputDecoration(labelText: 'Código de Barras'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o código de barras';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedMovementType,
                items: ['Entrada', 'Saída'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedMovementType = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Tipo de Movimentação'),
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a quantidade';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMovement,
                child: Text('Registrar Movimentação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

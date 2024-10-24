import 'package:flutter/material.dart';
import '../models/stock_movement.dart';
import '../database/database_helper.dart';

class StockMovementForm extends StatefulWidget {
  final bool isEntry;

  const StockMovementForm({super.key, required this.isEntry});

  @override
  _StockMovementFormState createState() => _StockMovementFormState();
}

class _StockMovementFormState extends State<StockMovementForm> {
  final _formKey = GlobalKey<FormState>();
  final _barCodeController = TextEditingController();
  final _quantityController = TextEditingController();

  Future<void> _saveMovement() async {
    if (_formKey.currentState!.validate()) {
      // Busca o produto pelo código de barras fornecido
      final product = await DatabaseHelper.instance
          .getProductByBarCode(_barCodeController.text);

      if (!mounted) return;

      if (product == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produto não encontrado no estoque')),
          );
        }
        return;
      }

      // Busca o estoque pelo productId encontrado
      final stock = await DatabaseHelper.instance.getStockByProductId(product.id!);

      if (stock == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Estoque não encontrado')),
          );
        }
        return;
      }

      final quantity =
          double.parse(_quantityController.text) * (widget.isEntry ? 1 : -1);

      final movement = StockMovement(
        productId: product.id!, // Usando productId em vez de barCode
        stockId: stock.id!,
        movementType: widget.isEntry ? 'Entrada' : 'Saída',
        quantity: quantity,
        movementDate: DateTime.now(),
      );

      await DatabaseHelper.instance.insertStockMovement(movement);
      await DatabaseHelper.instance.updateStockQuantity(movement);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movimentação registrada com sucesso!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEntry ? 'Entrada de Estoque' : 'Saída de Estoque'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _barCodeController,
                decoration:
                    const InputDecoration(labelText: 'Código de Barras'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o código de barras';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a quantidade';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Quantidade inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMovement,
                child: const Text('Registrar Movimentação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
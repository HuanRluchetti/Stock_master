import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; 
import '../models/product.dart';
import '../models/stock_movement.dart';
import '../database/database_helper.dart';

class StockMovementForm extends StatefulWidget {
  final int stockId;

  const StockMovementForm({super.key, required this.stockId});

  @override
  _StockMovementFormState createState() => _StockMovementFormState();
}

class _StockMovementFormState extends State<StockMovementForm> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  List<Product> _products = [];
  Product? _selectedProduct;
  String _movementType = 'entrada';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    final products = await DatabaseHelper.instance.getAllProducts();
    if (mounted) {
      setState(() {
        _products = products;
        _selectedProduct = _products.isNotEmpty ? _products.first : null;
      });
    }
  }

  Future<void> _saveMovement() async {
    if (_formKey.currentState!.validate() && _selectedProduct != null) {
      final movement = StockMovement(
        productId: _selectedProduct!.id!,
        stockId: widget.stockId,
        movementType: _movementType,
        quantity: double.parse(_quantityController.text),
        movementDate: DateTime.now(),
      );

      try {
        final db = await DatabaseHelper.instance.database;
        await db.transaction((txn) async {
          bool success = await _updateStock(txn, movement);
          if (success) {
            await txn.insert('stock_movement', movement.toMap());
          } else {
            throw Exception('Erro: Estoque insuficiente ou inválido.');
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Movimentação registrada com sucesso!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.toString()}')),
        );
      }
    }
  }

  Future<bool> _updateStock(Transaction txn, StockMovement movement) async {
    final result = await txn.query(
      'stock',
      where: 'product_id = ?',
      whereArgs: [movement.productId],
    );

    double updatedQuantity;
    if (result.isNotEmpty) {
      final currentQuantity = result.first['quantity'] as double;

      updatedQuantity = movement.movementType == 'entrada'
          ? currentQuantity + movement.quantity
          : currentQuantity - movement.quantity;

      if (updatedQuantity < 0) {
        return false;
      }

      await txn.update(
        'stock',
        {'quantity': updatedQuantity},
        where: 'product_id = ?',
        whereArgs: [movement.productId],
      );
    } else {
      if (movement.movementType == 'saida') {
        return false;
      }

      await txn.insert('stock', {
        'product_id': movement.productId,
        'quantity': movement.quantity,
        'entry_date': DateTime.now().toIso8601String(),
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movimentação de Estoque')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Product>(
                value: _selectedProduct,
                items: _products.map((product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Text(product.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProduct = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Produto'),
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
                    return 'Número inválido';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _movementType,
                items: const [
                  DropdownMenuItem(value: 'entrada', child: Text('Entrada')),
                  DropdownMenuItem(value: 'saida', child: Text('Saída')),
                ],
                onChanged: (value) {
                  setState(() {
                    _movementType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Tipo de Movimento'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMovement,
                child: const Text('Registrar Movimento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
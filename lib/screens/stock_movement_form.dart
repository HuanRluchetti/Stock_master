import 'package:flutter/material.dart';
import '../models/stock_movement.dart';
import '../database/database_helper.dart';

class StockMovementForm extends StatefulWidget {
  final StockMovement? stockMovement;

  StockMovementForm({this.stockMovement});

  @override
  _StockMovementFormState createState() => _StockMovementFormState();
}

class _StockMovementFormState extends State<StockMovementForm> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late String _productCode;
  late int _quantity;
  late String _date;

  @override
  void initState() {
    super.initState();
    _type = widget.stockMovement?.type ?? 'Entrada';
    _productCode = widget.stockMovement?.productCode ?? '';
    _quantity = widget.stockMovement?.quantity ?? 0;
    _date = widget.stockMovement?.date ?? DateTime.now().toIso8601String();
  }

  void _saveMovement() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final movement = StockMovement(
        id: widget.stockMovement?.id,
        type: _type,
        productCode: _productCode,
        quantity: _quantity,
        date: _date,
      );
      if (widget.stockMovement == null) {
        await DatabaseHelper.instance.insertStockMovement(movement);
      } else {
        await DatabaseHelper.instance.updateStockMovement(movement);
      }
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.stockMovement == null ? 'Nova Movimentação' : 'Editar Movimentação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: ['Entrada', 'Saída'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) => setState(() => _type = val!),
                decoration: InputDecoration(labelText: 'Tipo de Movimentação'),
                onSaved: (val) => _type = val!,
              ),
              TextFormField(
                initialValue: _productCode,
                decoration: InputDecoration(labelText: 'Código do Produto'),
                onSaved: (val) => _productCode = val!,
              ),
              TextFormField(
                initialValue: _quantity.toString(),
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _quantity = int.parse(val!),
              ),
              TextFormField(
                initialValue: _date,
                decoration: InputDecoration(labelText: 'Data'),
                onSaved: (val) => _date = val!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMovement,
                child: Text(widget.stockMovement == null ? 'Adicionar' : 'Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

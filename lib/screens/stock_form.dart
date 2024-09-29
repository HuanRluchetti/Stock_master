import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../database/database_helper.dart';

class StockForm extends StatefulWidget {
  final Stock? stock;

  StockForm({this.stock});

  @override
  _StockFormState createState() => _StockFormState();
}

class _StockFormState extends State<StockForm> {
  final _formKey = GlobalKey<FormState>();

  final _barCodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _paidValueController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _entryDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.stock != null) {
      _barCodeController.text = widget.stock!.barCode;
      _nameController.text = widget.stock!.name;
      _descriptionController.text = widget.stock!.description;
      _quantityController.text = widget.stock!.quantity.toString();
      _paidValueController.text = widget.stock!.paidValue.toString();
      _salePriceController.text = widget.stock!.salePrice.toString();
      _expiryDateController.text = widget.stock!.expiryDate.toIso8601String();
      _entryDateController.text = widget.stock!.entryDate.toIso8601String();
    }
  }

  void _saveStock() async {
    if (_formKey.currentState!.validate()) {
      final stock = Stock(
        barCode: _barCodeController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        quantity: double.parse(_quantityController.text),
        paidValue: double.parse(_paidValueController.text),
        salePrice: double.parse(_salePriceController.text),
        expiryDate: DateTime.parse(_expiryDateController.text),
        entryDate: DateTime.now(),
      );

      if (widget.stock == null) {
        await DatabaseHelper.instance.insertStock(stock);
      } else {
        await DatabaseHelper.instance.updateStock(stock);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(widget.stock == null
                ? 'Estoque cadastrado com sucesso!'
                : 'Estoque atualizado com sucesso!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.stock == null ? 'Cadastrar Estoque' : 'Editar Estoque'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a descrição';
                  }
                  return null;
                },
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
              TextFormField(
                controller: _paidValueController,
                decoration: InputDecoration(labelText: 'Valor Pago'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o valor pago';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salePriceController,
                decoration: InputDecoration(labelText: 'Preço de Venda'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o preço de venda';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expiryDateController,
                decoration: InputDecoration(labelText: 'Data de Validade'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a data de validade';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _entryDateController,
                decoration: InputDecoration(labelText: 'Data de Entrada'),
                keyboardType: TextInputType.datetime,
                readOnly: true,
                initialValue: DateTime.now().toIso8601String(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveStock,
                child: Text(widget.stock == null
                    ? 'Cadastrar Estoque'
                    : 'Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

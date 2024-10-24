import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../database/database_helper.dart';

class StockForm extends StatefulWidget {
  final Stock? stock;

  const StockForm({super.key, this.stock});

  @override
  _StockFormState createState() => _StockFormState();
}

class _StockFormState extends State<StockForm> {
  final _formKey = GlobalKey<FormState>();
  final _barCodeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _salePriceController = TextEditingController();
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    if (widget.stock != null) {
      _barCodeController.text = widget.stock!.productId.toString();
      _quantityController.text = widget.stock!.quantity.toString();
      _salePriceController.text = widget.stock!.salePrice.toString();
    }

    _barCodeController.addListener(_onFormChange);
    _quantityController.addListener(_onFormChange);
    _salePriceController.addListener(_onFormChange);
  }

  void _onFormChange() {
    setState(() {
      _hasChanged = widget.stock == null ||
          _barCodeController.text != widget.stock!.productId ||
          _quantityController.text != widget.stock!.quantity.toString() ||
          _salePriceController.text != widget.stock!.salePrice.toString();
    });
  }

  @override
  void dispose() {
    _barCodeController.dispose();
    _quantityController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }

  void _saveStock() async {
    if (_formKey.currentState!.validate()) {
      final stock = Stock(
        id: widget.stock?.id,
        productId: int.parse(_barCodeController.text),
        quantity: double.tryParse(_quantityController.text) ?? 0.0,
        salePrice: double.tryParse(_salePriceController.text) ?? 0.0,
        paidValue: widget.stock?.paidValue ?? 0.0,
        expiryDate: widget.stock?.expiryDate ?? DateTime.now(),
        entryDate: widget.stock?.entryDate ?? DateTime.now(),
      );

      if (widget.stock == null) {
        await DatabaseHelper.instance.insertStock(stock);
      } else {
        await DatabaseHelper.instance.updateStock(stock);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  void _deleteStock() async {
    if (widget.stock != null) {
      await DatabaseHelper.instance.deleteStock(widget.stock!.id!);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stock == null ? 'Cadastrar Estoque' : 'Editar Estoque'),
        actions: widget.stock != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteStock,
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _barCodeController,
                decoration: const InputDecoration(labelText: 'Código de Barras'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o código de barras do produto';
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
                    return 'Digite um valor numérico válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salePriceController,
                decoration: const InputDecoration(labelText: 'Preço de Venda'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o preço de venda';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Digite um valor numérico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _hasChanged ? _saveStock : null,
                child: Text(widget.stock == null ? 'Cadastrar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
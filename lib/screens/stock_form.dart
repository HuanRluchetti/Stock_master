import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../database/database_helper.dart';

class StockForm extends StatefulWidget {
  final Stock? stock;

  const StockForm({Key? key, this.stock}) : super(key: key);

  @override
  _StockFormState createState() => _StockFormState();
}

class _StockFormState extends State<StockForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _salePriceController = TextEditingController();
  bool _hasChanged = false; // Para monitorar mudanças no formulário

  @override
  void initState() {
    super.initState();
    if (widget.stock != null) {
      // Modo de edição: preencher os campos com os dados do produto
      _nameController.text = widget.stock!.name;
      _quantityController.text = widget.stock!.quantity.toString();
      _salePriceController.text = widget.stock!.salePrice.toString();
    }

    // Monitorar mudanças nos campos
    _nameController.addListener(_onFormChange);
    _quantityController.addListener(_onFormChange);
    _salePriceController.addListener(_onFormChange);
  }

  void _onFormChange() {
    if (widget.stock != null) {
      // Habilitar o botão "Salvar" apenas se houver alguma mudança no formulário
      setState(() {
        _hasChanged = _nameController.text != widget.stock!.name ||
            _quantityController.text != widget.stock!.quantity.toString() ||
            _salePriceController.text != widget.stock!.salePrice.toString();
      });
    } else {
      // Se estamos no modo de criação, sempre permitir salvar
      setState(() {
        _hasChanged = true;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }

  void _saveStock() async {
    if (_formKey.currentState!.validate()) {
      final stock = Stock(
        id: widget.stock?.id,
        barCode: '0000',
        name: _nameController.text,
        quantity: double.parse(_quantityController.text),
        salePrice: double.parse(_salePriceController.text),
        paidValue: 0.0,
        expiryDate: DateTime.now(),
        entryDate: DateTime.now(),
      );

      if (widget.stock == null) {
        // Inserir novo produto
        await DatabaseHelper.instance.insertStock(stock);
      } else {
        // Atualizar produto existente
        await DatabaseHelper.instance.updateStock(stock);
      }

      Navigator.pop(context, true); // Retornar para atualizar a lista
    }
  }

  void _deleteStock() async {
    if (widget.stock != null) {
      await DatabaseHelper.instance.deleteStock(widget.stock!.id!);
      Navigator.pop(context, true); // Retornar para atualizar a lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.stock == null ? 'Cadastrar Produto' : 'Editar Produto'),
        actions: widget.stock != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
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
              SizedBox(height: 20),
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

import 'package:flutter/material.dart';

class StockForm extends StatefulWidget {
  @override
  _StockFormState createState() => _StockFormState();
}

class _StockFormState extends State<StockForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String? _description;
  double? _quantity;
  double? _paidValue;
  double? _salePrice;
  String? _expiryDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Estoque'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                onSaved: (value) {
                  _description = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _quantity = double.tryParse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Valor Pago'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _paidValue = double.tryParse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço de Venda'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _salePrice = double.tryParse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Data de Validade'),
                onSaved: (value) {
                  _expiryDate = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Salvar no banco de dados
                    print('Estoque salvo: $_name, $_quantity');
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

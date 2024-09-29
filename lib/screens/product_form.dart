import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../database/database_helper.dart';

class ProductForm extends StatefulWidget {
  final Product? product;

  ProductForm({this.product});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final _barCodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _minQuantityController = TextEditingController();
  final _typeQuantityController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _paidValueController = TextEditingController();

  List<Category> _categories = [];
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      _barCodeController.text = widget.product!.barCode;
      _nameController.text = widget.product!.name;
      _minQuantityController.text = widget.product!.minQuantity.toString();
      _typeQuantityController.text = widget.product!.typeQuantity;
      _expiryDateController.text = widget.product!.expiryDate.toIso8601String();
      _paidValueController.text = widget.product!.paidValue.toString();
    }

    _fetchCategories();
  }

  void _fetchCategories() async {
    List<Category> categories =
        await DatabaseHelper.instance.getAllCategories();
    setState(() {
      _categories = categories;
      if (widget.product != null) {
        _selectedCategory = categories
            .firstWhere((cat) => cat.id == widget.product!.categoryId);
      }
    });
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        barCode: _barCodeController.text,
        stockId: 1, // Placeholder
        name: _nameController.text,
        image: null,
        minQuantity: double.parse(_minQuantityController.text),
        typeQuantity: _typeQuantityController.text,
        expiryDate: DateTime.parse(_expiryDateController.text),
        registrationDate: DateTime.now(),
        categoryId: _selectedCategory!.id!,
        paidValue: double.parse(_paidValueController.text),
      );

      if (widget.product == null) {
        await DatabaseHelper.instance.insertProduct(product);
      } else {
        await DatabaseHelper.instance.updateProduct(product);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.product == null
              ? 'Produto cadastrado com sucesso!'
              : 'Produto atualizado com sucesso!')));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.product == null ? 'Cadastrar Produto' : 'Editar Produto'),
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
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _minQuantityController,
                decoration: InputDecoration(labelText: 'Quantidade Mínima'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a quantidade mínima';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _typeQuantityController,
                decoration: InputDecoration(labelText: 'Tipo de Quantidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o tipo de quantidade';
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
              DropdownButtonFormField<Category>(
                decoration: InputDecoration(labelText: 'Categoria'),
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (Category? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione uma categoria';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(widget.product == null
                    ? 'Cadastrar Produto'
                    : 'Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

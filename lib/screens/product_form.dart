import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../database/database_helper.dart';
import '../models/stock.dart';

class ProductForm extends StatefulWidget {
  final Product? product;

  const ProductForm({super.key, this.product});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final _barCodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _minQuantityController = TextEditingController();
  final _quantityController = TextEditingController();
  final _typeQuantityController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _paidValueController = TextEditingController();
  final _salePriceController = TextEditingController();

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

      _loadStock(widget.product!.barCode); // Carrega estoque pelo código
    }
    _fetchCategories();
  }

  double _parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      print('Erro ao converter "$value" para double: $e');
      return 0.0;
    }
  }

  void _loadStock(String barCode) async {
    final stock = await DatabaseHelper.instance.getStockByBarCode(barCode);
    if (stock != null) {
      setState(() {
        _quantityController.text = stock.quantity.toString();
        _salePriceController.text = stock.salePrice.toString();
      });
    }
  }

  void _fetchCategories() async {
    List<Category> categories = await DatabaseHelper.instance.getAllCategories();
    setState(() {
      _categories = categories;
      if (widget.product != null) {
        _selectedCategory = categories.firstWhere(
          (cat) => cat.id == widget.product!.categoryId,
          orElse: () => categories.isNotEmpty
              ? categories.first
              : Category(id: -1, name: 'Desconhecido', description: ''),
        );
      }
    });
  }

  Future<void> _pickExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _expiryDateController.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione uma categoria')),
        );
        return;
      }

      final product = Product(
        id: widget.product?.id,
        barCode: _barCodeController.text,
        name: _nameController.text,
        minQuantity: _parseDouble(_minQuantityController.text),
        typeQuantity: _typeQuantityController.text,
        expiryDate: DateTime.parse(_expiryDateController.text),
        registrationDate: DateTime.now(),
        categoryId: _selectedCategory!.id!,
        paidValue: _parseDouble(_paidValueController.text),
      );

      if (widget.product == null) {
        await DatabaseHelper.instance.insertProduct(product);
      } else {
        await DatabaseHelper.instance.updateProduct(product);
      }

      final stock = Stock(
        productId: product.id!, // Código de barras como ID do estoque
        quantity: _parseDouble(_quantityController.text),
        paidValue: _parseDouble(_paidValueController.text),
        salePrice: _parseDouble(_salePriceController.text),
        expiryDate: DateTime.parse(_expiryDateController.text),
        entryDate: DateTime.now(),
      );

      await DatabaseHelper.instance.insertOrUpdateStock(stock);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto salvo com sucesso!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Cadastrar Produto' : 'Editar Produto',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTextField(
                controller: _barCodeController,
                label: 'Código de Barras',
                keyboardType: TextInputType.number,
                validator: 'Informe o código de barras',
              ),
              _buildTextField(
                controller: _nameController,
                label: 'Nome do Produto',
                validator: 'Informe o nome do produto',
              ),
              _buildTextField(
                controller: _minQuantityController,
                label: 'Quantidade Mínima',
                keyboardType: TextInputType.number,
                validator: 'Informe a quantidade mínima',
              ),
              _buildTextField(
                controller: _typeQuantityController,
                label: 'Tipo de Quantidade',
              ),
              _buildTextField(
                controller: _expiryDateController,
                label: 'Data de Validade',
                readOnly: true,
                onTap: () => _pickExpiryDate(context),
              ),
              _buildTextField(
                controller: _paidValueController,
                label: 'Valor Pago',
                keyboardType: TextInputType.number,
                validator: 'Informe o valor pago',
              ),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                items: _categories
                    .map((category) => DropdownMenuItem<Category>(
                          value: category,
                          child: Text(category.name),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Selecione uma Categoria',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text('Salvar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator != null
          ? (value) => value == null || value.isEmpty ? validator : null
          : null,
    );
  }
}
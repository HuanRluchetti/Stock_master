import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/categoryController.dart';
import '../controllers/productController.dart';
import '../models/product.dart';
import '../models/category.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  String barCode = '';
  int stockId = 1; // Substituir com uma lógica de seleção de estoque
  String name = '';
  String? image;
  double minQuantity = 0.0;
  String typeQuantity = '';
  String? expiryDate;
  String registrationDate = DateTime.now().toIso8601String();
  int? categoryId; // Agora pode ser nulo até ser selecionado
  double paidValue = 0.0;

  late List<Category> categories;
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categoryController =
        Provider.of<CategoryController>(context, listen: false);
    categories = await categoryController.getCategories();
    if (categories.isNotEmpty) {
      setState(() {
        selectedCategory =
            categories[0]; // Define a primeira categoria como padrão
        categoryId = selectedCategory?.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Produto')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Código de Barras'),
                onChanged: (value) {
                  setState(() {
                    barCode = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o código de barras';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Quantidade Mínima'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    minQuantity = double.parse(value);
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a quantidade mínima';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tipo de Quantidade'),
                onChanged: (value) {
                  setState(() {
                    typeQuantity = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Valor Pago'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    paidValue = double.parse(value);
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o valor pago';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<Category>(
                value: selectedCategory,
                items: categories.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (Category? newCategory) {
                  setState(() {
                    selectedCategory = newCategory;
                    categoryId = newCategory?.id;
                  });
                },
                decoration: InputDecoration(labelText: 'Categoria'),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma categoria';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newProduct = Product(
                      barCode: barCode,
                      stockId: stockId,
                      name: name,
                      image: image,
                      minQuantity: minQuantity,
                      typeQuantity: typeQuantity,
                      expiryDate: expiryDate,
                      registrationDate: registrationDate,
                      categoryId: categoryId!,
                      paidValue: paidValue,
                    );
                    Provider.of<ProductController>(context, listen: false)
                        .insertProduct(newProduct);
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

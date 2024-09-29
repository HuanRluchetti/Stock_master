import 'package:flutter/material.dart';
import '../models/category.dart';
import '../database/database_helper.dart';

class CategoryForm extends StatefulWidget {
  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      final category = Category(
        name: _nameController.text,
        description: _descriptionController.text,
      );

      await DatabaseHelper.instance.insertCategory(category);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Categoria cadastrada com sucesso!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Categoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome da Categoria'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome da categoria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a descrição da categoria';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCategory,
                child: Text('Cadastrar Categoria'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

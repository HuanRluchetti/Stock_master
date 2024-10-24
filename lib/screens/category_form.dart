import 'package:flutter/material.dart';
import '../models/category.dart';
import '../database/database_helper.dart';

class CategoryForm extends StatefulWidget {
  final Category? category;

  const CategoryForm({super.key, this.category});  // Usando super.key

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _descriptionController.text = widget.category!.description ?? '';
    }

    _nameController.addListener(_onFormChange);
    _descriptionController.addListener(_onFormChange);
  }

  void _onFormChange() {
    setState(() {
      _hasChanged = widget.category == null ||
          _nameController.text != widget.category!.name ||
          _descriptionController.text != (widget.category!.description ?? '');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      final category = Category(
        id: widget.category?.id,
        name: _nameController.text,
        description: _descriptionController.text,
      );

      if (widget.category == null) {
        await DatabaseHelper.instance.insertCategory(category);
      } else {
        await DatabaseHelper.instance.updateCategory(category);
      }

      if (mounted) {
        Navigator.pop(context, true);  // Verificando se o widget ainda está montado
      }
    }
  }

  Future<void> _deleteCategory() async {
    if (widget.category != null) {
      await DatabaseHelper.instance.deleteCategory(widget.category!.id!);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null
            ? 'Cadastrar Categoria'
            : 'Editar Categoria'),
        actions: widget.category != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteCategory,
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
                decoration: const InputDecoration(labelText: 'Nome da Categoria'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome da categoria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição (opcional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _hasChanged ? _saveCategory : null,
                child: Text(widget.category == null ? 'Cadastrar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
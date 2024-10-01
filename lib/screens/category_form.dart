import 'package:flutter/material.dart';
import '../models/category.dart';
import '../database/database_helper.dart';

class CategoryForm extends StatefulWidget {
  final Category? category;

  const CategoryForm({Key? key, this.category}) : super(key: key);

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _hasChanged = false; // Para monitorar mudanças no formulário

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      // Modo de edição: preencher os campos com os dados da categoria
      _nameController.text = widget.category!.name;
      _descriptionController.text = widget.category!.description ?? '';
    }

    // Monitorar mudanças nos campos
    _nameController.addListener(_onFormChange);
    _descriptionController.addListener(_onFormChange);
  }

  void _onFormChange() {
    if (widget.category != null) {
      // Habilitar o botão "Salvar" apenas se houver alguma mudança no formulário
      setState(() {
        _hasChanged = _nameController.text != widget.category!.name ||
            _descriptionController.text != (widget.category!.description ?? '');
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
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      final category = Category(
        id: widget.category?.id,
        name: _nameController.text,
        description: _descriptionController.text,
      );

      if (widget.category == null) {
        // Inserir nova categoria
        await DatabaseHelper.instance.insertCategory(category);
      } else {
        // Atualizar categoria existente
        await DatabaseHelper.instance.updateCategory(category);
      }

      Navigator.pop(context, true); // Retornar para atualizar a lista
    }
  }

  void _deleteCategory() async {
    if (widget.category != null) {
      await DatabaseHelper.instance.deleteCategory(widget.category!.id!);
      Navigator.pop(context, true); // Retornar para atualizar a lista
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
                  icon: Icon(Icons.delete),
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
                decoration: InputDecoration(labelText: 'Descrição (opcional)'),
              ),
              SizedBox(height: 20),
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

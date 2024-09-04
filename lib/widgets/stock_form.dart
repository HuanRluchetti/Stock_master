import 'package:flutter/material.dart';

class StockForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
            child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Nome Estoque:'),
            ),
          ],
        )),
      ),
    );
  }
}
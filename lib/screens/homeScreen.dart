import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/category');
              },
              child: Text('Cadastrar Categoria'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/product');
              },
              child: Text('Cadastrar Produto'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/stock');
              },
              child: Text('Cadastrar Estoque'),
            ),
          ],
        ),
      ),
    );
  }
}

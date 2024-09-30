import 'package:flutter/material.dart';
import 'package:stock_master/screens/category_form.dart';
import 'package:stock_master/screens/category_list.dart';
import 'package:stock_master/screens/stock_form.dart';
import 'package:stock_master/screens/stock_list.dart';
import 'package:stock_master/screens/stock_movement.dart';
import 'package:stock_master/screens/stock_movement_list.dart';
import '/screens/product_form.dart';
import '/screens/product_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Produtos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Master'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductList()),
                );
              },
              child: Text('Listar Produtos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryList()),
                );
              },
              child: Text('Listar Categorias'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockList()),
                );
              },
              child: Text('Listar Estoque'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockMovementList()),
                );
              },
              child: Text('Listar movimentação'),
            ),
          ],
        ),
      ),
    );
  }
}

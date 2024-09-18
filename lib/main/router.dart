import 'package:flutter/material.dart';
import '../widgets/categoryForm.dart';
import '../widgets/productForm.dart';
import '../widgets/stockForm.dart';
import '../widgets/homeScreen.dart'; // Tela inicial para navegação entre opções // Tela inicial para navegação entre opções

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/category':
        return MaterialPageRoute(builder: (_) => CategoryForm());
      case '/product':
        return MaterialPageRoute(builder: (_) => ProductForm());
      case '/stock':
        return MaterialPageRoute(builder: (_) => StockForm());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text('Erro')),
          body: Center(child: Text('Rota não encontrada')),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/categoryController.dart';
import '../controllers/productController.dart';
import '../controllers/stockController.dart';
import 'router.dart';
import '../database/databaseProvider.dart'; // Arquivo fictício para gerenciar o banco de dados

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supondo que o banco de dados seja providenciado através do `DatabaseProvider`
  final database = await DatabaseProvider().initDB();

  runApp(
    MultiProvider(
      providers: [
        Provider<CategoryController>(
            create: (_) => CategoryController(database)),
        Provider<ProductController>(create: (_) => ProductController(database)),
        Provider<StockController>(create: (_) => StockController(database)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Estoque',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

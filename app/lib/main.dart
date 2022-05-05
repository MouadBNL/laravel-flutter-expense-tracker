import 'package:app/screens/CategoriesScreen.dart';
import 'package:app/screens/LoginScreen.dart';
import 'package:app/screens/RegisterScreen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:app/providers/category.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter app',
        home: LoginScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/categories': (context) => CategoriesScreen()
        },
      ),
    );
  }
}

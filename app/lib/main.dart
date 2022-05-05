import 'package:app/providers/auth.dart';
import 'package:app/screens/CategoriesScreen.dart';
import 'package:app/screens/HomeScreen.dart';
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
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<CategoryProvider>(
                create: (context) => CategoryProvider(),
              ),
              ChangeNotifierProvider<AuthProvider>(
                create: (context) => AuthProvider(),
              ),
            ],
            child: MaterialApp(
              title: 'Flutter app',
              routes: {
                '/': (context) {
                  final authProvider = Provider.of<AuthProvider>(context);
                  if (authProvider.isAuthenticated) {
                    return HomeScreen();
                  }
                  return LoginScreen();
                },
                '/login': (context) => LoginScreen(),
                '/register': (context) => RegisterScreen(),
                '/categories': (context) => CategoriesScreen(),
              },
            ),
          );
        },
      ),
    );
  }
}

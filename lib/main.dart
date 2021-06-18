import 'package:flutter/material.dart';
import 'package:login_validation_bloc/bloc/provider.dart';
import 'package:login_validation_bloc/pages/home_page.dart';
import 'package:login_validation_bloc/pages/login_page.dart';
import 'package:login_validation_bloc/pages/product_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'login': (_) => LoginPage(),
          'home': (_) => HomePage(),
          'product': (_) => ProductPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}

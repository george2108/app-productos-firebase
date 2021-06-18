import 'package:flutter/material.dart';
import 'package:login_validation_bloc/bloc/provider.dart';
import 'package:login_validation_bloc/pages/home_page.dart';
import 'package:login_validation_bloc/pages/login_page.dart';
import 'package:login_validation_bloc/pages/product_page.dart';
import 'package:login_validation_bloc/pages/register_page.dart';
import 'package:login_validation_bloc/utils/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new SharedPreferencesUser();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new SharedPreferencesUser();
    print(prefs.token);
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (_) => LoginPage(),
          'home': (_) => HomePage(),
          'product': (_) => ProductPage(),
          'register': (_) => RegisterPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:login_validation_bloc/models/product_model.dart';
import 'package:login_validation_bloc/utils/shared_preferences.dart';

class ProductProvider {
  final String _url = 'https://flutter-app-5418b-default-rtdb.firebaseio.com';
  final _prefs = new SharedPreferencesUser();

  Future<List<ProductModel>> getAllProducts() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(response.body);
    final List<ProductModel> productList = [];
    if (data == null) return [];
    data.forEach((id, product) {
      final productTemp = ProductModel.fromJson(product);
      productTemp.id = id;
      productList.add(productTemp);
    });
    return productList;
  }

  Future<int> deleteProduct(String id) async {
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final response = await http.delete(Uri.parse(url));
    print(json.decode(response.body));
    return 1;
  }

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final response = await http.post(
      Uri.parse(url),
      body: productModelToJson(product),
    );
    final data = json.decode(response.body);
    print(data);
    return true;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final url = '$_url/productos/${product.id}.json?auth=${_prefs.token}';
    final response = await http.put(
      Uri.parse(url),
      body: productModelToJson(product),
    );
    final data = json.decode(response.body);
    print(data);
    return true;
  }
}

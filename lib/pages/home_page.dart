import 'package:flutter/material.dart';
import 'package:login_validation_bloc/models/product_model.dart';
import 'package:login_validation_bloc/providers/products_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productsProvider = new ProductProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _productosList(),
      floatingActionButton: _customFloatingActionButton(),
    );
  }

  Widget _productosList() {
    return FutureBuilder(
      future: productsProvider.getAllProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final productList = snapshot.data;
          return ListView.builder(
            itemCount: productList.length,
            itemBuilder: (BuildContext context, i) =>
                _itemProducts(context, productList[i]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _itemProducts(BuildContext context, ProductModel product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        productsProvider.deleteProduct(product.id);
      },
      child: Card(
        child: Column(
          children: [
            product.fotoUrl == null
                ? Image(
                    image: AssetImage('assets/no-image.png'),
                  )
                : FadeInImage(
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    image: NetworkImage(product.fotoUrl),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${product.nombre} - ${product.valor}'),
              subtitle: Text(product.id),
              onTap: () =>
                  Navigator.pushNamed(context, 'product', arguments: product)
                      .then((value) {
                setState(() {});
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'product').then((value) {
        setState(() {});
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:login_validation_bloc/models/product_model.dart';
import 'package:login_validation_bloc/providers/products_provider.dart';
import 'package:login_validation_bloc/providers/upload_file_provider.dart';
import 'package:login_validation_bloc/utils/utils.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final productProvider = new ProductProvider();
  final uploadFileProvider = new UploadFileProvider();
  ProductModel product = new ProductModel();

  bool _guardando = false;

  File filePhoto;

  @override
  Widget build(BuildContext context) {
    final ProductModel productArgument =
        ModalRoute.of(context).settings.arguments;
    if (productArgument != null) product = productArgument;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectImage,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takePicture,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _showImage(),
                SizedBox(height: 15.0),
                _productName(),
                SizedBox(height: 15.0),
                _productPrice(),
                SizedBox(height: 15.0),
                _productAvailable(),
                SizedBox(height: 15.0),
                _buttonSaveProduct(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showImage() {
    if (product.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(product.fotoUrl),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: filePhoto != null
            ? FileImage(filePhoto)
            : AssetImage('assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _selectImage() async {
    _takeAndSelectPicture(ImageSource.gallery);
  }

  _takePicture() async {
    _takeAndSelectPicture(ImageSource.camera);
  }

  _takeAndSelectPicture(ImageSource origin) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: origin,
    );
    filePhoto = File(pickedFile.path);
    if (filePhoto != null) {
      product.fotoUrl = null;
    }

    setState(() {});
  }

  Widget _productName() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      initialValue: product.nombre,
      decoration: InputDecoration(
        labelText: 'Nombre',
        hintText: "Nombre del producto",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      // se ejecuta despues de validar el campo
      onSaved: (value) => product.nombre = value,
      validator: (value) {
        return value.trim().length < 1 ? 'Nombre demasiado corto' : null;
      },
    );
  }

  Widget _productPrice() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      initialValue: product.valor.toString(),
      decoration: InputDecoration(
        labelText: 'Precio',
        hintText: "Precio del producto",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onSaved: (value) => product.valor = double.parse(value),
      validator: (value) {
        if (isANumber(value)) {
          return null;
        }
        return 'No es un precio correcto';
      },
    );
  }

  Widget _productAvailable() {
    return SwitchListTile(
      value: product.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) {
        setState(() {
          product.disponible = value;
        });
      },
    );
  }

  Widget _buttonSaveProduct() {
    return RaisedButton.icon(
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      color: Colors.deepPurple,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: _guardando ? null : _submitAction,
    );
  }

  void _submitAction() async {
    if (!formKey.currentState.validate()) return;

    // guarda el valor de los campos del formulario
    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (filePhoto != null) {
      product.fotoUrl = await uploadFileProvider.uploadFile(filePhoto);
    }

    // codigo si es valido
    if (product.id == null) {
      productProvider.createProduct(product);
    } else {
      productProvider.updateProduct(product);
    }
    showSnackBar('Registro guardado');
    Navigator.pop(context);
  }

  void showSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}

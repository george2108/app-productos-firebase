// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String id;
  String nombre;
  double valor;
  bool disponible;
  String fotoUrl;

  ProductModel({
    this.id,
    this.nombre = '',
    this.valor = 0.00,
    this.disponible = true,
    this.fotoUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        nombre: json["nombre"],
        valor: json["valor"],
        disponible: json["disponible"],
        fotoUrl: json["fotoUrl"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "nombre": nombre,
        "valor": valor,
        "disponible": disponible,
        "fotoUrl": fotoUrl,
      };
}

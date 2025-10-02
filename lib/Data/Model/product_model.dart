import 'dart:convert';

class ProductModel {
  final String id;
  final String productName;
  final String productUrl;
  final String productType;
  final String price;
  final List<String> concernList;
  final List<String> skinType;
  final List<String> ingredients;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productUrl,
    required this.productType,
    required this.price,
    required this.concernList,
    required this.skinType,
    required this.ingredients,
  });

  ProductModel copyWith({
    String? id,
    String? productName,
    String? productUrl,
    String? productType,
    String? price,
    List<String>? concernList,
    List<String>? skinType,
    List<String>? ingredients,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      productUrl: productUrl ?? this.productUrl,
      productType: productType ?? this.productType,
      price: price ?? this.price,
      concernList: concernList ?? this.concernList,
      skinType: skinType ?? this.skinType,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_name': productName,
      'product_url': productUrl,
      'product_type': productType,
      'price': price,
      'concern_list': concernList,
      'skin_type': skinType,
      'ingredients': ingredients,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      productName: map['product_name'] ?? '',
      productUrl: map['product_url'] ?? '',
      productType: map['product_type'] ?? '',
      price: map['price'],
      concernList: List<String>.from(map['concern_list'] ?? []),
      skinType: List<String>.from(map['skin_type'] ?? []),
      ingredients: List<String>.from(map['ingredients'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}

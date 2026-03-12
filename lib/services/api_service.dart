import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final List list = body as List;

      return list.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch products. Code: ${response.statusCode}');
    }
  }
}
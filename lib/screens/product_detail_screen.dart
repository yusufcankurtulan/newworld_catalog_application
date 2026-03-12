import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/cart_model.dart';
import '../services/currency_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'KGfonts',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ValueListenableBuilder<String>(
                  valueListenable: CurrencyService.currencyNotifier,
                  builder: (context, currency, _) {
                    final sym = CurrencyService.symbol();
                    final rate = CurrencyService.convert(product.price);
                    final discounted = CurrencyService.convert(product.price * 0.8);
                    return Row(
                      children: [
                        Text(
                          '${rate.toStringAsFixed(2)} $sym',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${discounted.toStringAsFixed(2)} $sym',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '%20 Discount',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(product.description),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                cart.add(product, discount: 20);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Product added to cart! %20 discount applied.\n'
                        'New price: ${CurrencyService.convert(product.price * 0.8).toStringAsFixed(2)} ${CurrencyService.symbol()}',
                    ),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

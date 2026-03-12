import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../services/currency_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
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
      ),
        body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                            'Cart',
                          cart.totalItems.toString(),
                          Icons.shopping_cart,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                        Expanded(
                          child: ValueListenableBuilder<String>(
                            valueListenable: CurrencyService.currencyNotifier,
                            builder: (context, currency, _) {
                              return _buildStatCard(
                                'Total Price',
                                '${CurrencyService.convert(cart.totalPrice).toStringAsFixed(2)} ${CurrencyService.symbol()}',
                                Icons.attach_money,
                                Colors.green,
                              );
                            },
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }



}
import 'package:flutter/material.dart';

import '../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
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
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, _) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text('Sepetiniz boş.'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(item.product.image),
                              onBackgroundImageError: (_, __) {},
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Adet: ${item.quantity}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  if (item.discountPercent > 0) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Orijinal: ${item.originalPrice.toStringAsFixed(2)} \$ | %${item.discountPercent.toStringAsFixed(0)} İndirim',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 4),
                                  Text(
                                    'Birim Fiyat: ${item.discountedPrice.toStringAsFixed(2)} \$',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (item.totalDiscount > 0) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Tasarruf: ${item.totalDiscount.toStringAsFixed(2)} \$',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${item.totalPrice.toStringAsFixed(2)} \$',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      iconSize: 18,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => cart.decrement(item.product),
                                      tooltip: 'Adet azalt',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      iconSize: 18,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => cart.add(item.product, discount: item.discountPercent),
                                      tooltip: 'Adet artır',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      iconSize: 18,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => cart.remove(item.product),
                                      tooltip: 'Sil',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (cart.items.any((item) => item.totalDiscount > 0))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Toplam Tasarruf: ${cart.items.fold<double>(0, (prev, item) => prev + item.totalDiscount).toStringAsFixed(2)} \$',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'İndirimlerle ${((cart.items.fold<double>(0, (prev, item) => prev + (item.originalPrice * item.quantity)) - cart.totalPrice) / cart.items.fold<double>(0, (prev, item) => prev + (item.originalPrice * item.quantity)) * 100).toStringAsFixed(1)}% tasarruf yaptınız!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Toplam:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${cart.totalPrice.toStringAsFixed(2)} \$',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        _showPaymentDialog(context);
                      },
                      child: const Text('Ödemeyi Tamamla (Simülasyon)'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ödeme Onayı'),
          content: Text(
            'Toplam tutar: ${cart.totalPrice.toStringAsFixed(2)} \$\n\n'
            'Bu bir ödeme simülasyonudur. Devam etmek istiyor musunuz?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Vazgeç'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Onayla'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      cart.clear();
      if (context.mounted) {
        Navigator.of(context).pop(); // Sepet ekranından geri dön
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ödeme başarılı! (Simülasyon)'),
          ),
        );
      }
    }
  }
}


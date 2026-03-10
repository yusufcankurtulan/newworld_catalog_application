import 'package:flutter/foundation.dart';

import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final double discountPercent;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.discountPercent = 0,
  });

  double get originalPrice => product.price;
  double get discountedPrice => originalPrice * (1 - discountPercent / 100);
  double get totalPrice => discountedPrice * quantity;
  double get totalDiscount => (originalPrice - discountedPrice) * quantity;
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems =>
      _items.fold<int>(0, (previousValue, element) => previousValue + element.quantity);

  double get totalPrice =>
      _items.fold<double>(0, (previousValue, element) => previousValue + element.totalPrice);

  void add(Product product, {double discount = 20}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(product: product, discountPercent: discount));
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void decrement(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final item = _items[index];
      if (item.quantity > 1) {
        item.quantity -= 1;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

final CartModel cart = CartModel();


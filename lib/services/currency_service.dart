import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyService {
  static String _current = 'TRY';

  static const Map<String, double> _rates = {
    'USD': 1.0,
    'TRY': 20.0,
    'EUR': 0.9,
  };

  static ValueNotifier<String> currencyNotifier = ValueNotifier(_current);

  static Future<void> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _current = prefs.getString('selectedCurrency') ?? 'TRY';
    currencyNotifier.value = _current;
  }

  static Future<void> setCurrency(String currency) async {
    _current = currency;
    currencyNotifier.value = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCurrency', currency);
  }

  static String get currentCurrency => _current;

  static double convert(double amount) {
    final rate = _rates[_current] ?? 1.0;
    return amount * rate;
  }

  static String symbol() {
    switch (_current) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'TRY':
      default:
        return '₺';
    }
  }
}

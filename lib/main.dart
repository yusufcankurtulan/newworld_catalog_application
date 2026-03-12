import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/currency_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    CurrencyService.loadCurrency();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'New World',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey,
      ),
      home: _isLoggedIn ? const MainScreen() : LoginScreen(),
    );
  }
}

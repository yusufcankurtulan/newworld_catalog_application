import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import '../models/cart_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const CartScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
      )
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.grey[200],
      elevation: 8,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },

      items:  [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [

              const Icon(Icons.shopping_cart),

              if (cart.totalItems > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  constraints: const BoxConstraints(
                    minWidth: 13,
                    minHeight: 13,
                  ),
                  child: Text(
                    cart.totalItems.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        label: "Cart",
        ),
         const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    ),
  ),
),
);
}
}
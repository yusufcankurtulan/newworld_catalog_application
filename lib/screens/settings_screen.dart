import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/currency_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedCurrency = 'TRY';
  final List<String> _currencies = ['TRY', 'USD', 'EUR'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    CurrencyService.loadCurrency();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = prefs.getString('selectedCurrency') ??
          CurrencyService.currentCurrency;
    });
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showAccountDialog() {
    final userController = TextEditingController();
    final emailController = TextEditingController();
    String oldPassword = '';
    String newPassword = '';

    AuthService.getCurrentUser().then((user) {
      if (user != null) {
        userController.text = user['username'] ?? '';
        emailController.text = user['email'] ?? '';
      }
    });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Account Information'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: userController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 12),
                    const Text('Change Password'),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Old Password'),
                      obscureText: true,
                      onChanged: (v) => oldPassword = v,
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'New Password'),
                      obscureText: true,
                      onChanged: (v) => newPassword = v,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool success = true;
                    if (userController.text.isNotEmpty ||
                        emailController.text.isNotEmpty) {
                      success = await AuthService.updateProfile(
                        username: userController.text.isNotEmpty
                            ? userController.text
                            : null,
                        email: emailController.text.isNotEmpty
                            ? emailController.text
                            : null,
                      );
                    }
                    if (success &&
                        oldPassword.isNotEmpty &&
                        newPassword.isNotEmpty) {
                      success =
                          await AuthService.changePassword(oldPassword, newPassword);
                    }
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? 'Information updated successfully.'
                            : 'An error occurred during update.'),
                      ),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('Account Settings'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildMenuItem(
                  Icons.person_outline,
                  'Account Information',
                  'Manage your personal info',
                  () {
                    _showAccountDialog();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('App Settings'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildMenuItem(
                  Icons.attach_money,
                  'Currency',
                  _selectedCurrency,
                  () => _showCurrencyDialog(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.red[50],
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text('Log out of your account safely'),
              onTap: () => _logout(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _currencies.map((currency) {
            return RadioListTile<String>(
              title: Text(currency),
              value: currency,
              groupValue: _selectedCurrency,
              onChanged: (value) async {
                setState(() => _selectedCurrency = value!);
                await CurrencyService.setCurrency(value!);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$value currency selected')),
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}


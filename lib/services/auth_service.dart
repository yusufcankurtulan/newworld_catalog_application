import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<bool> register(String username, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final existingUser = await getUserByEmail(email);
      if (existingUser != null) {
        return false; 
      }

      final userData = {
        'username': username,
        'email': email,
        'password': password, 
        'createdAt': DateTime.now().toIso8601String(),
      };

      await prefs.setString(_userKey, jsonEncode(userData));
      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userKey);

      if (userDataString == null) {
        return false; 
      }

      final userData = jsonDecode(userDataString);

      if (userData['email'] == email && userData['password'] == password) {
        await prefs.setBool(_isLoggedInKey, true);
        return true;
      }

      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userKey);

      if (userDataString == null) return null;

      return jsonDecode(userDataString);
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userKey);

      if (userDataString == null) return null;

      final userData = jsonDecode(userDataString);
      if (userData['email'] == email) {
        return userData;
      }

      return null;
    } catch (e) {
      print('Get user by email error: $e');
      return null;
    }
  }

  static Future<bool> updateProfile({String? username, String? email}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userKey);
      if (userDataString == null) return false;
      final userData = jsonDecode(userDataString);
      if (email != null && email != userData['email']) {
        final existing = await getUserByEmail(email);
        if (existing != null) return false; 
        userData['email'] = email;
      }
      if (username != null) {
        userData['username'] = username;
      }
      await prefs.setString(_userKey, jsonEncode(userData));
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  static Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userKey);
      if (userDataString == null) return false;
      final userData = jsonDecode(userDataString);
      if (userData['password'] != oldPassword) {
        return false;
      }
      userData['password'] = newPassword;
      await prefs.setString(_userKey, jsonEncode(userData));
      return true;
    } catch (e) {
      print('Change password error: $e');
      return false;
    }
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_isLoggedInKey);
  }
}
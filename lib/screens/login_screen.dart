import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'register_screen.dart';
import 'main_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email or password is incorrect')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to New World',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color(0xFF1C1C1C),
                ),
              ),            
              SizedBox(height: 26),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  labelText: 'Email',
  
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 49,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1C1C1C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: RichText(
    text: TextSpan(
      text: "Don't have an account? ",
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        color: Color(0xFF1C1C1C),
      ),
      children: [
        TextSpan(
          text: "Sign Up",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Color(0xFF1C1C1C), 
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegisterScreen(),
                ),
              );
            },
        ),
      ],
    ),
  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
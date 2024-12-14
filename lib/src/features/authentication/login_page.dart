import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';
import 'package:myguide_app/src/features/authentication/register_page.dart';
import 'package:myguide_app/src/features/home/homepage.dart';
import 'package:myguide_app/src/features/shop/shop_login_page.dart'; // Importando a página de login da shop
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../guest/guest_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> _loginUser() async {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
    final response = await http.get(
      Uri.parse('${apiUrl}users/${_emailController.text}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Verifica se a senha está correta
      return data['password'] == _passwordController.text;
    }
    return false;
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void _login() async {
    final loginSuccessful = await _loginUser();
    if (loginSuccessful) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  // Função para redirecionar para a página de convidado
  void _loginAsGuest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GuestHomePage()), // Redireciona para a página de convidado
    );
  }

  // Função para redirecionar para a página de login da shop
  void _loginAsShop() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ShopLoginPage()), // Redireciona para a página de login da shop
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: thirdColor,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Find your next souvenir",
                    style: GoogleFonts.italianno(fontSize: 45, color: primaryColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text(
                      "Discover the charm of local shops and hidden gems with our innovative app designed to enhance your shopping experience.",
                      style: TextStyle(color: primaryColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 152, 0, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _navigateToRegister,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 11),
                      child: Text(
                        "Don't have an account? Create",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      'assets/images/welcome_images/myguide.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField("Email", _emailController, false),
                  const SizedBox(height: 20),
                  _buildTextField("Password", _passwordController, true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
                    ),
                    onPressed: _login,
                    child: const Text('Login', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _loginAsGuest,
                    child: const Text(
                      'Continue as Guest',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _loginAsShop,
                    child: const Text(
                      'Login as Shop',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, bool isPassword) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: thirdColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';
import 'package:myguide_app/src/features/home/page/homepage.dart'; // Página após o login
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myguide_app/src/features/shop/shop_manager_page.dart';

class ShopLoginPage extends StatefulWidget {
  const ShopLoginPage({super.key});

  @override
  _ShopLoginPageState createState() => _ShopLoginPageState();
}

class _ShopLoginPageState extends State<ShopLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Função para realizar o login sem verificação de email e senha
  void _login() {
    // Simplesmente navega para a HomePage diretamente
    if (!mounted) return;
   // Após autenticação bem-sucedida de uma loja, navegue para a página de gerenciamento.
   Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ShopManagementPage()), // Sem passar o parâmetro 'shop'
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              _buildTextField("Email", _emailController, false), // Email removido da lógica de login
              const SizedBox(height: 20),
              _buildTextField("Password", _passwordController, true), // Senha removida da lógica de login
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
                ),
                onPressed: _login, // Função de login simplificada
                child: const Text('Login', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
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

import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';
import 'package:myguide_app/src/features/shop/shop_manager_page.dart'; // Página após o login
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  // Função para realizar o login com a requisição ao endpoint 'shops'
  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter both email and password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      String apiUrl = dotenv.env['API_URL'] ?? 'default_api_url'; // URL da API do backend

      // Fazendo a requisição GET para obter a lista de lojas
      final response = await http.get(
        Uri.parse('${apiUrl}shops'),  // URL do endpoint de lojas
      );

      if (response.statusCode == 200) {
        List<dynamic> shops = jsonDecode(response.body);

        // Verificando se algum shop tem email e senha correspondentes
        bool isAuthenticated = false;
        for (var shop in shops) {
          if (shop['email'] == email && shop['password'] == password) {
            isAuthenticated = true;
            break;
          }
        }

        if (isAuthenticated) {
          // Se encontrar a loja, redireciona para a página de gerenciamento
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ShopManagementPage()),
          );
        } else {
          // Caso o email e senha não sejam encontrados
          Fluttertoast.showToast(
            msg: "Invalid credentials, please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        // Caso o servidor retorne um erro diferente de 200
        Fluttertoast.showToast(
          msg: "An error occurred. Please try again later.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      // Caso ocorra um erro de rede ou outro erro inesperado
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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

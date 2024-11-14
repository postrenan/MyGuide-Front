import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myguide_app/src/constants/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterShop extends StatefulWidget {
  const RegisterShop({super.key});

  @override
  _RegisterShopState createState() => _RegisterShopState();
}

class _RegisterShopState extends State<RegisterShop> {
  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  Future<void> _createShopAccount() async {
    // Validação dos campos obrigatórios
    if (_emailController.text.isEmpty ||
        _shopNameController.text.isEmpty ||
        _countryController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _repeatPasswordController.text.isEmpty) {
      _showMessage('Please fill all fields');
      return;
    }

    // Verificação se as senhas coincidem
    if (_passwordController.text != _repeatPasswordController.text) {
      _showMessage('Passwords do not match');
      return;
    }

    try {
      String apiKey = dotenv.env['API_URL'] ?? 'default_api_key';

      final response = await http.post(
        Uri.parse('${apiKey}shops'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'name': _shopNameController.text,
          'country': _countryController.text,
          'city': _cityController.text,
          'address': _addressController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Exibir mensagem de sucesso
        Fluttertoast.showToast(
          msg: "Shop account created successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Redireciona para a página de login ou outro fluxo
        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        _showMessage('Invalid data. Please check your inputs.');
      } else {
        _showMessage('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showMessage('An error occurred. Please try again.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _shopNameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Add shop information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField("Email", 350, _emailController),
              const SizedBox(height: 20),
              _buildTextField("Shop Name", 350, _shopNameController),
              const SizedBox(height: 20),
              _buildTextField("Country", 350, _countryController),
              const SizedBox(height: 20),
              _buildTextField("City", 350, _cityController),
              const SizedBox(height: 20),
              _buildTextField("Address", 350, _addressController),
              const SizedBox(height: 20),
              _buildPasswordField("Password", 350, _isPasswordVisible, () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }, _passwordController),
              const SizedBox(height: 20),
              _buildPasswordField("Repeat Password", 350, _isRepeatPasswordVisible, () {
                setState(() {
                  _isRepeatPasswordVisible = !_isRepeatPasswordVisible;
                });
              }, _repeatPasswordController),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _createShopAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secundaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Create account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, double width, TextEditingController controller) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hintText, double width, bool isPasswordVisible, VoidCallback toggleVisibility, TextEditingController controller) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controller,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: toggleVisibility,
            ),
          ),
        ),
      ),
    );
  }
}

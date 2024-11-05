import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';
import 'package:myguide_app/src/features/authentication/screens/register_shop.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  Future<void> _createCredentials() async {
    // Verificação de campos obrigatórios
    if (_emailController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _birthdayController.text.isEmpty ||
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
      final response = await http.post(
        Uri.parse('https://myguide-api.renanbick.com/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'name': _nameController.text,
          'username': _usernameController.text,
          'birthday': _birthdayController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        _showMessage('Account created successfully');
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
    _nameController.dispose();
    _usernameController.dispose();
    _birthdayController.dispose();
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
                "Add your information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterShop()),
                  );
                },
                child: const Text(
                  'Are you a shop owner?',
                  style: TextStyle(
                    color: secundaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField("Email", 350, _emailController),
              const SizedBox(height: 20),
              _buildTextField("Full Name", 350, _nameController),
              const SizedBox(height: 20),
              _buildTextField("Username", 350, _usernameController),
              const SizedBox(height: 20),
              _buildTextField("Birthday", 350, _birthdayController),
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
                onPressed: () {
                  _createCredentials();
                },
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

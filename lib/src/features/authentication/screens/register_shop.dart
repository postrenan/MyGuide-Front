import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';

class RegisterShop extends StatefulWidget {
  const RegisterShop({Key? key}) : super(key: key);

  @override
  _RegisterShopState createState() => _RegisterShopState();
}

class _RegisterShopState extends State<RegisterShop> {
  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        leading: BackButton(), 
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
              _buildTextField("Email", 350),
              const SizedBox(height: 20),
              _buildTextField("Shop Name", 350),
              const SizedBox(height: 20),
              _buildTextField("Country", 350),
              const SizedBox(height: 20),
              _buildTextField("City", 350),
              const SizedBox(height: 20),
              _buildTextField("Address", 350), 
              const SizedBox(height: 20),
              _buildPasswordField("Password", 350, _isPasswordVisible, () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),
              const SizedBox(height: 20),
              _buildPasswordField("Repeat Password", 350, _isRepeatPasswordVisible, () {
                setState(() {
                  _isRepeatPasswordVisible = !_isRepeatPasswordVisible;
                });
              }),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {}, //cadastro------------------------
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

  Widget _buildTextField(String hintText, double width) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hintText, double width, bool isPasswordVisible, VoidCallback toggleVisibility) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
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

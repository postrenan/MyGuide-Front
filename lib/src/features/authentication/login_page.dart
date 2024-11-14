import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';
import 'package:myguide_app/src/features/authentication/register_page.dart';
import 'package:myguide_app/src/features/home/page/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatelessWidget {
  final ValueNotifier<bool> _rememberMe = ValueNotifier<bool>(true);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  Future<bool> _loginUser() async {
    String apiKey = dotenv.env['API_URL'] ?? 'default_api_url';

    final response = await http.post(
      Uri.parse('${apiKey}users/login'), // Endpoint de login
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['exists'] == true; // verifica se o usuário existe e foi autenticado
    } else {
      return false; // login falhou
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  style: GoogleFonts.italianno(
                    fontSize: 45,
                    color: primaryColor,
                  ),
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
                    backgroundColor: secundaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
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
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: thirdColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: thirdColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _rememberMe,
                      builder: (context, value, child) {
                        return Checkbox(
                          value: value,
                          activeColor: Colors.black,
                          onChanged: (newValue) {
                            _rememberMe.value = newValue!;
                          },
                        );
                      },
                    ),
                    const Text('remember me?',
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 130, vertical: 20),
                  ),
                  onPressed: () async {
                    bool loginSuccessful = await _loginUser();

                    if (loginSuccessful) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Login failed. Please try again.')),
                      );
                    }
                  },
                  child: const Text('Login',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

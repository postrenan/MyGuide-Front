import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myguide_app/src/constants/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myguide_app/src/features/authentication/login_page.dart';

class RegisterShop extends StatefulWidget {
  const RegisterShop({super.key});

  @override
  _RegisterShopState createState() => _RegisterShopState();
}

class _RegisterShopState extends State<RegisterShop> {
  bool _isPasswordVisible = false;
  final bool _isRepeatPasswordVisible = false;
  int _currentStep = 0;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _productsController = TextEditingController();
  final TextEditingController _openTimeController = TextEditingController();
  final TextEditingController _closeTimeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  List<dynamic> _categories = [];
  String? _selectedCategoryName;
  int? _selectedCategoryId; // Alterado para armazenar o ID da categoria
  String _selectedPrice = 'low'; // Valor padrão
  String _selectedProducts = '10'; // Valor padrão

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final now = DateTime.now();
      final isoTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      ).toIso8601String();
      setState(() {
        controller.text = isoTime;
      });
    }
  }

  Widget _buildTimePickerField(
      String label, double width, TextEditingController controller) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectTime(context, controller),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
          suffixIcon: const Icon(Icons.access_time),
        ),
      ),
    );
  }

  Future<void> _fetchCategories() async {
    try {
      String apiKey = dotenv.env['API_URL'] ?? 'default_api_key';
      final response = await http.get(Uri.parse('${apiKey}categories'));

      if (response.statusCode == 200) {
        final List<dynamic> categories = jsonDecode(response.body);
        setState(() {
          _categories = categories;
        });
      } else {
        _showMessage('Failed to load categories');
      }
    } catch (e) {
      _showMessage('An error occurred while loading categories');
    }
  }

  Future<void> _createShopAccount() async {
    if (_emailController.text.isEmpty ||
        _shopNameController.text.isEmpty ||
        _countryController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _streetController.text.isEmpty ||
        _numberController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _openTimeController.text.isEmpty ||
        _closeTimeController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _repeatPasswordController.text.isEmpty ||
        _selectedCategoryId ==
            null || // Verifique se o id da categoria foi selecionado
        _stateController.text.isEmpty) {
      _showMessage('Please fill all fields and select a category');
      return;
    }

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
        body: jsonEncode(<String, dynamic>{
          'email': _emailController.text,
          'name': _shopNameController.text,
          'country': _countryController.text,
          'city': _cityController.text,
          'street': _streetController.text,
          'number': int.tryParse(_numberController.text) ?? 0,
          'description': _descriptionController.text,
          'price': _selectedPrice,
          'categoryId': _selectedCategoryId, // Envia o id da categoria
          'products': int.tryParse(_productsController.text) ?? 0,
          'openTime': _openTimeController.text,
          'closeTime': _closeTimeController.text,
          'password': _passwordController.text,
          'state': _stateController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Exibe a notificação de sucesso no canto inferior direito
        Fluttertoast.showToast(
          msg: "Shop account created successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Redireciona para a página de login
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        ); // Certifique-se de ter configurado a rota '/login' no seu app
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
    _streetController.dispose();
    _numberController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _productsController.dispose();
    _openTimeController.dispose();
    _closeTimeController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
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
              if (_currentStep == 0) _buildStepWithButtons(_buildStep1()),
              if (_currentStep == 1) _buildStepWithButtons(_buildStep2()),
              if (_currentStep == 2) _buildStepWithButtons(_buildStep3()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepWithButtons(Widget stepContent) {
    return Column(
      children: [
        stepContent,
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (_currentStep > 0)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Back"),
              ),
            ElevatedButton(
              onPressed: _currentStep == 2
                  ? _createShopAccount
                  : () {
                      setState(() {
                        _currentStep++;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(_currentStep == 2 ? "Conclude" : "Next"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        _buildTextField("Email", 350, _emailController),
        const SizedBox(height: 20),
        _buildTextField("Shop Name", 350, _shopNameController),
        const SizedBox(height: 20),
        _buildTextField("Country", 350, _countryController),
        const SizedBox(height: 20),
        _buildTextField("City", 350, _cityController),
        const SizedBox(height: 20),
        _buildTextField("State", 350, _stateController),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        _buildTextField("Street", 350, _streetController),
        const SizedBox(height: 20),
        _buildTextField("Number", 350, _numberController,
            inputType: TextInputType.number),
        const SizedBox(height: 20),
        _buildTextField("Description", 350, _descriptionController),
        const SizedBox(height: 20),
        _buildDropdownField(
          label: "Price",
          value: _selectedPrice,
          items: ["low", "moderate", "high"],
          onChanged: (value) {
            setState(() {
              _selectedPrice = value!;
            });
          },
        ),
        const SizedBox(height: 20),
        _buildDropdownField(
          label: "Products",
          value: _selectedProducts,
          items: ["10", "20", "30", "50", "100+"],
          onChanged: (value) {
            setState(() {
              _selectedProducts = value!;
            });
          },
        ),
        const SizedBox(height: 20),
        _buildDropdownField(
          label: "Category",
          value:
              _selectedCategoryName ?? _categories[0]['name'], // Valor padrão
          items: _categories
              .map((category) => category['name'].toString())
              .toList(),
          onChanged: (value) {
            setState(() {
              // A categoria selecionada agora armazena o id
              _selectedCategoryId = _categories
                  .firstWhere((category) => category['name'] == value)['id'];
              _selectedCategoryName = value; // Exibe o nome da categoria
            });
          },
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        _buildTimePickerField("Open Time", 350, _openTimeController),
        const SizedBox(height: 20),
        _buildTimePickerField("Close Time", 350, _closeTimeController),
        const SizedBox(height: 20),
        _buildTextField("Password", 350, _passwordController, isPassword: true),
        const SizedBox(height: 20),
        _buildTextField("Repeat Password", 350, _repeatPasswordController,
            isPassword: true),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    double width,
    TextEditingController controller, {
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        obscureText: isPassword && !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              const TextStyle(color: Colors.black), // Cor do texto do label
          filled: true, // Adiciona cor de fundo
          fillColor: Colors.white, // Cor de fundo do campo
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Bordas arredondadas
            borderSide: const BorderSide(
                color: Colors.orange, width: 2), // Cor e espessura da borda
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
                color: Colors.orange, width: 2), // Cor e espessura da borda
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
                color: Colors.orange,
                width: 2), // Cor e espessura da borda quando focado
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      width: 350, // Adicionando a mesma largura dos outros inputs
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              const TextStyle(color: Colors.black), // Cor do texto do label
          filled: true, // Adiciona cor de fundo
          fillColor: Colors.white, // Cor de fundo do campo
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Bordas arredondadas
            borderSide: const BorderSide(
                color: Colors.orange, width: 2), // Cor e espessura da borda
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
                color: Colors.orange, width: 2), // Cor e espessura da borda
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
                color: Colors.orange,
                width: 2), // Cor e espessura da borda quando focado
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

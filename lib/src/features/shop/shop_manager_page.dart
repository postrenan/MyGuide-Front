import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Para salvar e remover dados

class ShopManagementPage extends StatefulWidget {
  const ShopManagementPage({super.key});

  @override
  _ShopManagementPageState createState() => _ShopManagementPageState();
}

class _ShopManagementPageState extends State<ShopManagementPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _openTimeController = TextEditingController();
  final TextEditingController _closeTimeController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();

  bool _isLoading = false;
  List<Map<String, dynamic>> _products = []; // Lista de produtos

  String _shopId = ''; // ID da loja para buscar os dados

  // Função para carregar os dados da loja
  Future<void> _loadShopData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/'; 
      final response = await http.get(Uri.parse('${apiUrl}shops/$_shopId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nameController.text = data['name'];
          _descriptionController.text = data['description'];
          _openTimeController.text = data['openTime'];
          _closeTimeController.text = data['closeTime'];
        });
      } else {
        throw Exception('Failed to load shop data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading shop data')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para carregar os produtos da loja
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
      final response = await http.get(Uri.parse('${apiUrl}shops/$_shopId/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading products')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para atualizar as informações da loja
  Future<void> _updateShop() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
      final response = await http.put(
        Uri.parse('$apiUrl/shops/$_shopId'),
        body: {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'openTime': _openTimeController.text,
          'closeTime': _closeTimeController.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shop updated successfully')),
        );
      } else {
        throw Exception('Failed to update shop');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating shop')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para adicionar um novo produto
  Future<void> _addProduct() async {
    if (_productNameController.text.isEmpty || _productPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all product details')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
      final response = await http.post(
        Uri.parse('$apiUrl/shops/$_shopId/products'),
        body: {
          'name': _productNameController.text,
          'price': _productPriceController.text,
        },
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
        _productNameController.clear();
        _productPriceController.clear();
        _loadProducts(); // Recarregar os produtos
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding product')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para excluir um produto
  Future<void> _deleteProduct(String productId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
      final response = await http.delete(
        Uri.parse('$apiUrl/shops/$_shopId/products/$productId'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')),
        );
        _loadProducts(); // Recarregar os produtos após exclusão
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting product')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para realizar o logout
  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpa todos os dados armazenados
    Navigator.pushReplacementNamed(context, '/login'); // Redireciona para a tela de login
  }

  @override
  void initState() {
    super.initState();
    _shopId = '123'; // Exemplo de shopId, substitua com a lógica de pegar o ID correto
    _loadShopData(); // Carregar os dados da loja ao iniciar
    _loadProducts(); // Carregar os produtos da loja ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Your Shop'),
        backgroundColor: const Color(0xFF273F57),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout, // Chamando a função de logout
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shop Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Shop Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Shop Description'),
              ),
              TextField(
                controller: _openTimeController,
                decoration: const InputDecoration(labelText: 'Open Time'),
              ),
              TextField(
                controller: _closeTimeController,
                decoration: const InputDecoration(labelText: 'Close Time'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateShop,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Update Shop'),
              ),
              const SizedBox(height: 40),

              // Add New Product Section
              const Text(
                'Add New Product',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: _productPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Product Price'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _addProduct,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Add Product'),
              ),
              const SizedBox(height: 40),

              // List of Products
              const Text(
                'Product List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return ListTile(
                          title: Text(product['name']),
                          subtitle: Text('\$${product['price']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _productNameController.text = product['name'];
                                  _productPriceController.text = product['price'].toString();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteProduct(product['id']);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

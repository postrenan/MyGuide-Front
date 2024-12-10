import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Dados para cada seção
  List<dynamic> _shops = [];
  List<dynamic> _users = [];
  List<dynamic> _locations = [];
  List<dynamic> _products = [];

  // Dados filtrados para pesquisa
  List<dynamic> _filteredShops = [];
  List<dynamic> _filteredUsers = [];
  List<dynamic> _filteredLocations = [];
  List<dynamic> _filteredProducts = [];

  bool _isLoading = false;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _fetchData(); // Carrega os dados da API
  }

  // Função para buscar dados da API
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
      
      // Buscando os dados de lojas, usuários, locais e produtos
      final responseShops = await http.get(Uri.parse('${apiUrl}shops'));
      final responseUsers = await http.get(Uri.parse('${apiUrl}users'));
      final responseLocations = await http.get(Uri.parse('${apiUrl}locations'));
      final responseProducts = await http.get(Uri.parse('${apiUrl}products'));

      if (responseShops.statusCode == 200 &&
          responseUsers.statusCode == 200 &&
          responseLocations.statusCode == 200 &&
          responseProducts.statusCode == 200) {

        setState(() {
          _shops = json.decode(responseShops.body);
          _users = json.decode(responseUsers.body);
          _locations = json.decode(responseLocations.body);
          _products = json.decode(responseProducts.body);
          _filteredShops = _shops;
          _filteredUsers = _users;
          _filteredLocations = _locations;
          _filteredProducts = _products;
          _isLoading = false;
        });
      } else {
        throw Exception('Error fetching data from the API');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load data.')),
      );
    }
  }

  // Função para filtrar os dados com base no termo de pesquisa
  void _filterData(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
      
      // Filtra os dados de cada categoria
      _filteredShops = _shops.where((shop) {
        return shop['name'].toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
      
      _filteredUsers = _users.where((user) {
        return user['name'].toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
      
      _filteredLocations = _locations.where((location) {
        return location['name'].toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
      
      _filteredProducts = _products.where((product) {
        return product['name'].toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF273F57),
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              // Lógica de logout, se necessário
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Campo de pesquisa global
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: _filterData,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            // Exibição dos dados em TabBarView
            Expanded(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Shops'),
                        Tab(text: 'Users'),
                        Tab(text: 'Locations'),
                        Tab(text: 'Products'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Lojas
                          _buildDataTab(_filteredShops, 'name', 'Shop Name', 'Shop Address'),
                          // Usuários
                          _buildDataTab(_filteredUsers, 'name', 'User Name', 'Email'),
                          // Locais
                          _buildDataTab(_filteredLocations, 'name', 'Location Name', 'Location Address'),
                          // Produtos
                          _buildDataTab(_filteredProducts, 'name', 'Product Name', 'Category'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para construir cada aba de dados (lojas, usuários, locais, produtos)
  Widget _buildDataTab(List<dynamic> data, String nameField, String nameLabel, String secondaryLabel) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          elevation: 8,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(item[nameField] ?? 'Unknown'),
            subtitle: Text(item[secondaryLabel] ?? 'No information'),
          ),
        );
      },
    );
  }
}

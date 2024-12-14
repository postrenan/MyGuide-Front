import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:myguide_app/src/features/authentication/login_page.dart';
import 'package:myguide_app/src/features/home/sidebar/reviews.dart';
import 'package:myguide_app/src/features/shop/shop_page.dart'; // Importar a página de lojas

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<dynamic> _shops = [];
  List<dynamic> _filteredShops = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _searchTerm = '';
  int _selectedIndex = 0; // Controle do índice da aba selecionada
  bool _isDarkMode = false; // Controle do tema (dark/light)

  // Função para fazer logout e limpar dados do usuário
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Função para buscar dados da API
  Future<void> _fetchShops() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
      final response = await http.get(Uri.parse('${apiUrl}shops'));

      if (response.statusCode == 200) {
        final List<dynamic> newShops = json.decode(response.body);

        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _shops.addAll(newShops);
          _filteredShops = _shops;
          _hasMore = newShops.length == 15;
        });
      } else {
        throw Exception('Error fetching data from the API');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load shops.')),
      );
    }
  }

  // Função para filtrar as lojas com base no termo de busca
  void _filterShops(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
      if (searchTerm.isEmpty) {
        _filteredShops = _shops;
      } else {
        _filteredShops = _shops.where((shop) {
          return shop['name'].toLowerCase().contains(searchTerm.toLowerCase());
        }).toList();
      }
    });
  }

  // Função para navegar até os detalhes da loja
  void _navigateToShopDetail(dynamic shop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopPage(shop: shop),
      ),
    );
  }

  // Função para alternar o modo entre Dark e Light
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchShops(); // Carrega os dados da API
  }

  @override
  Widget build(BuildContext context) {
    // Determina o tema com base no valor de _isDarkMode
    final ThemeData theme = _isDarkMode ? ThemeData.dark() : ThemeData.light();

    List<Widget> pages = [
      Scaffold( // Página inicial com lojas
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 8.0),
                      child: Image.asset(
                        'assets/images/home/my.png',
                        height: 150,
                        width: 160,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Where are you going?',
                  style: GoogleFonts.italianno(
                    fontSize: 72,
                    color: const Color(0xFF273F57),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 500,
                  child: TextField(
                    onChanged: _filterShops,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search,
                          color: Color(0xFF273F57)),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                if (_isLoading && _filteredShops.isEmpty)
                  const CircularProgressIndicator()
                else if (_filteredShops.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No shops found.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                    ),
                    itemCount: _filteredShops.length,
                    itemBuilder: (context, index) {
                      final shop = _filteredShops[index];
                      final imageUrl =
                          'https://picsum.photos/200/150?random=$index';

                      return GestureDetector(
                        onTap: () => _navigateToShopDetail(shop),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                child: Image.network(
                                  imageUrl,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  shop['name'] ?? 'Unknown Shop',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                child: Text(
                                  shop['address'] ?? 'Unknown address',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                if (_hasMore && !_isLoading)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _fetchShops,
                      child: const Text('Load more'),
                    ),
                  ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    '© 2024 MyGuide App | All Rights Reserved',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const ReviewsPage(), // Página de Reviews
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF273F57),
        iconTheme: const IconThemeData(color: Colors.white), // Ícone do menu em branco
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('User'),
              accountEmail: Text('user@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              title: const Text('Shops'),
              leading: const Icon(Icons.store),
              onTap: () {
                setState(() {
                  _selectedIndex = 0; // Navegar para a página de Shops
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Reviews'),
              leading: const Icon(Icons.star),
              onTap: () {
                setState(() {
                  _selectedIndex = 1; // Navegar para a página de Reviews
                });
                Navigator.pop(context);
              },
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: (value) {
                _toggleTheme();
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex], // Exibe a página baseada no índice selecionado
    );
  }
}
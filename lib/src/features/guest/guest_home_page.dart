import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:myguide_app/src/features/authentication/login_page.dart';
import 'package:myguide_app/src/features/shop/shop_page.dart';

class GuestHomePage extends StatefulWidget {
  const GuestHomePage({super.key});

  @override
  _GuestHomePageState createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  final List<dynamic> _shops = [];
  List<dynamic> _filteredShops = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _searchTerm = '';
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme

  @override
  void initState() {
    super.initState();
    _fetchShops(); // Load shop data
  }

  // Function to log out and clear user data
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Function to fetch shops from the API
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

  // Function to filter shops based on the search term
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

  // Function to navigate to the shop details page
  void _navigateToShopDetail(dynamic shop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopPage(shop: shop),
      ),
    );
  }

  // Function to toggle between light and dark theme
  void _toggleTheme() {
    setState(() {
      _themeMode = (_themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyGuide App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode, // Use the current themeMode state
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF273F57),
          title: Padding(
            padding: const EdgeInsets.only(left: 20.0), // Left padding
            child: Text(
              'MyGuide', // Title on the left
              style: GoogleFonts.italianno(
                fontSize: 72,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              onPressed: () {
                _logout(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.brightness_6, color: Colors.white),
              onPressed: _toggleTheme, // Toggle between light and dark mode
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF273F57),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const GuestHomePage()),
                  );
                },
              ),
              ListTile(
                title: const Text('Favorites'),
                onTap: () {
                  // Navigate to favorites page
                },
              ),
              ListTile(
                title: const Text('Best Shops'),
                onTap: () {
                  // Navigate to best shops page
                },
              ),
              ListTile(
                title: const Text('Reviews'),
                onTap: () {
                  // Navigate to reviews page
                },
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFE0E0E0),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // Responsive
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
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF273F57)),
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
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                    ),
                    itemCount: _filteredShops.length,
                    itemBuilder: (context, index) {
                      final shop = _filteredShops[index];
                      final imageUrl = shop['imageUrl'] ?? 'https://picsum.photos/200/150?random=$index';

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
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                child: Text(
                                  shop['address'] ?? 'Unknown address',
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
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
    );
  }
}

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
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _fetchShops();
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

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

  void _navigateToShopDetail(dynamic shop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopPage(shop: shop),
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = (_themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyGuide App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF273F57),
          background: Color(0xFFF5F5F5),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1A1A2E),
          background: Color(0xFF121212),
          surface: Color(0xFF1F1F1F),
          onSurface: Colors.white,
        ),
        cardColor: const Color(0xFF1E1E2C),
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            bodyMedium: TextStyle(color: Colors.white70),
            bodySmall: TextStyle(color: Colors.white),
          ),
        ),
      ),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF273F57),
        
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              onPressed: () {
                _logout(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.brightness_6, color: Colors.white),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
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
                      crossAxisCount: 3,
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
                          color: Theme.of(context).cardColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: Image.network(
                                  imageUrl,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  shop['name'] ?? 'Unknown Shop',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shop['address'] ?? 'Unknown address',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rating: ${shop['rating'] ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                                                               color: Theme.of(context).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rating: ${shop['rating'] ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                if (_isLoading && _hasMore)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

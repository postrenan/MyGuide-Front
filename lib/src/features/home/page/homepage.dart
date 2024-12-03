import 'package:flutter/material.dart';
import 'package:myguide_app/src/features/home/page/carousel.dart';
import 'package:myguide_app/src/features/home/links/favorites.dart';
import 'package:myguide_app/src/features/home/links/reviews.dart';
import 'package:myguide_app/src/features/home/links/bestshops.dart';
import 'package:myguide_app/src/features/authentication/login_page.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _locationEnabled = false;
  bool notadmin = false; 

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  void _toggleLocation() {
    setState(() {
      _locationEnabled = !_locationEnabled;
    });
  }

  void _showProfileModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profile Management'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              TextField(
                controller: _birthdayController,
                decoration: const InputDecoration(labelText: 'Birthday'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthdayController.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                // Adicione a lógica para salvar as alterações aqui
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF273F57), // Azul
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoritesPage()),
                );
              },
              child: const Text(
                'Favorites',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 250.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReviewsPage()),
                );
              },
              child: const Text(
                'Reviews',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 250.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BestShopsPage()),
                );
              },
              child: const Text(
                'Best Shops',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE0E0E0), // Cinza claro
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
                  Padding(
                    padding: const EdgeInsets.only(right: 50.0),
                    child: IconButton(
                      icon: const Icon(Icons.person, color: Color(0xFFFF9800), size: 40), // Laranja
                      onPressed: () {
                        _showProfileModal(context);
                      },
                    ),
                  ),
                ],
              ),
              Text(
                'Where are you going?',
                style: GoogleFonts.italianno(
                  fontSize: 72,
                  color: const Color(0xFF273F57), // Azul
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 500,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF273F57)), // Azul
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: _toggleLocation,
                icon: Icon(
                  _locationEnabled ? Icons.location_off : Icons.location_on,
                  color: Colors.white,
                ),
                label: Text(
                  _locationEnabled ? 'Disable location' : 'Use your location',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800), // Laranja
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              if (_locationEnabled) ...[
                const MyCarousel(
                  title: 'category 1',
                  itemNames: ['shop 1', 'shop 2', 'shop 3', 'shop 4', 'shop 5', 'shop 6', 'shop 7', 'shop 8'],
                ),
                const SizedBox(height: 15.0),
                const MyCarousel(
                  title: 'category 2',
                  itemNames: ['shop 1', 'shop 2', 'shop 3', 'shop 4', 'shop 5', 'shop 6', 'shop 7', 'shop 8'],
                ),
                const SizedBox(height: 15.0),
                const MyCarousel(
                  title: 'category 3',
                  itemNames: ['shop 1', 'shop 2', 'shop 3', 'shop 4', 'shop 5', 'shop 6', 'shop 7', 'shop 8'],
                ),
                const SizedBox(height: 15.0),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Location blocked',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
